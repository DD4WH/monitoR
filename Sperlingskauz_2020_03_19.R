######################################
#
# Auto - ID
# Sperlingskauz Frühjahr
#
# Frank Dziock, 19.3.2020
#
######################################

library(monitoR)
library(tuneR)
library(warbleR)
library(bioacoustics)
library(seewave)

#################################################

Training_dir <- "f:/Lehre/11_SS2020/AutoID Sperlingskauz/Training"

#Classification_dir <- "f:/Lehre/11_SS2020/AutoID Sperlingskauz/Classification/real"
Classification_dir <- "e:/00_Audio/Sperlingskauz Dresdner Heide/2020/SK05 Rec26"

# plugin to XenoCanto ???

# maybe better to choose files manually

# conversion from MP3 to WAV
setwd(Training_dir)
mp32wav()

# resampling to 48ksps sample rate
T1.fp <- file.path(Training_dir, "XC506423.wav")
T2.fp <- file.path(Training_dir, "XC524560.wav")
T3.fp <- file.path(Training_dir, "XC413427.wav")
WAV1 <- readWave(T1.fp)
WAV2 <- readWave(T2.fp)
WAV3 <- readWave(T3.fp)
?savewav
savewav(WAV1, 48000, filename="T1.wav")
savewav(WAV2, 48000, filename="T2.wav")
savewav(WAV3, 48000, filename="T3.wav")

# use training file to create template (list)
T1.fp <- file.path(Training_dir, "T1.wav")
T2.fp <- file.path(Training_dir, "T2.wav")
T3.fp <- file.path(Training_dir, "T3.wav")

Template1 <- makeBinTemplate(T1.fp, amp.cutoff = -34, score.cutoff = 3, t.lim = c(2, 3.1),
                         frq.lim = c(0.4, 4), buffer = 1, name = "t1", wl=256)
Template2 <- makeBinTemplate(T2.fp, amp.cutoff = -32, score.cutoff = 3, t.lim = c(4.5, 5.6),
                             frq.lim = c(1, 3.2), buffer = 0, name = "t2", wl=512)
Template3 <- makeBinTemplate(T3.fp, amp.cutoff = -25, score.cutoff = 3, t.lim = c(8, 9),
                             frq.lim = c(1, 3.5), buffer = 0, name = "t3", wl=512)

TemplateCombi <- combineBinTemplates(Template1, Template2, Template3)

##### BATCHBINMATCH #####

#templateCutoff(TemplateCombi) <- c(11,11,11)

# conversion from MP3 to WAV
setwd(Classification_dir)
mp32wav()
C1 <- readWave(paste(Classification_dir,"SK1.wav", sep="/"))
C2 <- readWave(paste(Classification_dir,"SK2.wav", sep="/"))
C3 <- readWave(paste(Classification_dir,"SK3.wav", sep="/"))
C4 <- readWave(paste(Classification_dir,"SK4.wav", sep="/"))
C5 <- readWave(paste(Classification_dir,"SK5.wav", sep="/"))
savewav(C1, 48000, filename="SK1.wav")
savewav(C2, 48000, filename="SK2.wav")
savewav(C3, 48000, filename="SK3.wav")
savewav(C4, 48000, filename="SK3.wav")
savewav(C5, 48000, filename="SK3.wav")

time_start <- Sys.time()
Scores <- batchBinMatch(dir.survey= Classification_dir, 
                          ext.survey= "wav", templates= TemplateCombi, parallel = FALSE, show.prog = TRUE, 
                          warn = FALSE) 

#Scores

# FERTIG !!!
setwd(Classification_dir)
write.csv2(Scores, file = "SperlingskauzSK05_Rec26.csv")

Classification_dir <- "e:/00_Audio/Sperlingskauz Dresdner Heide/2020/SK05 Rec25 alter Buchenstamm"
Scores <- batchBinMatch(dir.survey= Classification_dir, 
                        ext.survey= "wav", templates= TemplateCombi, parallel = FALSE, show.prog = TRUE, 
                        warn = FALSE) 
write.csv2(Scores, file = "SperlingskauzSK05_Rec25.csv")

time_end <- Sys.time()

time_end - time_start


##################
# Testset
#################
# make Classifier
T1.fp <- file.path(Training_dir, "T1.wav")
T3.fp <- file.path(Training_dir, "T3.wav")
T4.fp <- file.path(Training_dir, "T4_SK25_2020_03_28_07_12_00_Sperlingskauz.wav")
T5.fp <- file.path(Training_dir, "T5_SK25_2020_03_28_07_15_00_Sperlingskauz.wav")
T6.fp <- file.path(Training_dir, "T6_SK26_2020_03_28_07_14_00_Sperlingskauz.wav")

Template1 <- makeBinTemplate(T1.fp, amp.cutoff = -32, score.cutoff = 3, t.lim = c(2, 8.2),
                             frq.lim = c(1, 2), buffer = 1, name = "t1", wl=2048)
Template3 <- makeBinTemplate(T3.fp, amp.cutoff = -25, score.cutoff = 3, t.lim = c(1.5, 5),
                             frq.lim = c(1.2, 1.7), buffer = 0, name = "t3", wl=2048)
Template4 <- makeBinTemplate(T4.fp, amp.cutoff = -34, score.cutoff = 3, t.lim = c(4.2, 8),
                             frq.lim = c(1.1, 1.8), buffer = 0, name = "t4", wl=2048)
Template5 <- makeBinTemplate(T5.fp, amp.cutoff = -36, score.cutoff = 3, t.lim = c(24, 28),
                             frq.lim = c(1.2, 1.6), buffer = 0, name = "t5", wl=1024)
Template6 <- makeBinTemplate(T6.fp, amp.cutoff = -36, score.cutoff = 3, t.lim = c(48.5,51.5),
                             frq.lim = c(1.2, 1.6), buffer = 0, name = "t6", wl=4096)

TemplateCombi <- combineBinTemplates(Template1, Template2, Template4, Template5, Template6)

# apply Classifier

Classification_dir <- "f:/Lehre/11_SS2020/AutoID Sperlingskauz/Classification/Testset"

time_start <- Sys.time()
Scores <- batchBinMatch(dir.survey= Classification_dir, 
                        ext.survey= "wav", templates= TemplateCombi, parallel = FALSE, show.prog = TRUE, 
                        warn = FALSE) 
setwd(Classification_dir)

write.csv2(Scores, file = "Sperlingskauz_TestSet_T3_4_5.csv")

time_end <- Sys.time()

time_end - time_start

##########################################
#
#
# apply 5 classifiers to all WAVs
#
#
##########################################
Classification_dir <- "e:/00_Audio/Sperlingskauz Dresdner Heide/2020/SK05 Rec25 alter Buchenstamm"
time_start <- Sys.time()
Scores <- batchBinMatch(dir.survey= Classification_dir, 
                        ext.survey= "wav", templates= TemplateCombi, parallel = FALSE, show.prog = TRUE, 
                        warn = FALSE) 
write.csv2(Scores, file = "SperlingskauzSK05_Rec25_5_classifiers.csv")

time_end <- Sys.time()

time_end - time_start

SK_IDscores=aggregate(Scores$score,by=list(Scores$id),FUN=max)

SK_IDscores

write.csv2(SK_IDscores, file = "Sperlingskauz_SK05 Rec25_ID_agg.csv")


Classification_dir <- "e:/00_Audio/Sperlingskauz Dresdner Heide/2020/SK05 Rec26"
time_start <- Sys.time()
Scores <- batchBinMatch(dir.survey= Classification_dir, 
                        ext.survey= "wav", templates= TemplateCombi, parallel = FALSE, show.prog = TRUE, 
                        warn = FALSE) 
write.csv2(Scores, file = "SperlingskauzSK05_Rec25_5_classifiers.csv")

time_end <- Sys.time()

time_end - time_start

SK_IDscores=aggregate(Scores$score,by=list(Scores$id),FUN=max)

SK_IDscores

write.csv2(SK_IDscores, file = "Sperlingskauz_SK05 Rec25_ID_agg.csv")

#####################################################
#
#
# write Scores file with aggregated data 
#
# we need MAX of Score for each WAV.-file
#
# maybe for each Classifier?
# maybe SUM ?
# maybe MEAN ?
#
#
#####################################################

SK_IDscores=aggregate(Scores$score,by=list(Scores$id),FUN=max)

SK_IDscores

write.csv2(SK_IDscores, file = "Sperlingskauz_TestSet_T3_4_5_ID_agg.csv")

SK_IDscores=aggregate(Scores$score,by=list(Scores$id),FUN=sum)

SK_IDscores

write.csv2(SK_IDscores, file = "Sperlingskauz_TestSet_T3_4_5_ID_agg_sum.csv")

##################################################################################

##### BATCHCORMATCH #####

cor15 <- makeCorTemplate(WK15t.fp, amp.cutoff = -32.5, score.cutoff = 0.16, t.lim = c(14.16, 15),
                         frq.lim = c(1.8, 6.8), buffer = 0, name = "w15", wl=128)
cor19 <- makeCorTemplate(WK19t.fp, amp.cutoff = -20, score.cutoff = 0.16, t.lim = c(1.5, 2.5),
                         frq.lim = c(1.5, 8), buffer = 0, name = "w19", wl=128)

Cor_templates <- combineCorTemplates(cor15, cor19)


?makeCorTemplate

# dies ist nicht die richtige Syntax!
#templateCutoff(btemps2) <- c(default = 3)
#templateCutoff(btemps2) <- c(3,3)
#templateCutoff(Cor_templates) <- c(1,1)

?batchCorMatch

Cor_template_scores <- batchCorMatch(dir.survey= dir_files, 
                          ext.survey= "wav", templates= Cor_templates, parallel = FALSE, show.prog = TRUE, 
                          warn = FALSE) 

Cor_template_scores

write.csv2(Cor_template_scores, file = "Cor_template_scores.csv")

# FERTIG !!!











###################################################################################
# dies wird alles nicht gebraucht

getDetections(cc_score, which.one = btemps2, id = NULL) #Error not an S4 object
getPeaks(cc_score)  #Error not an S4 object

showClass("detectionList")
cc_det <- showPeaks(cc_score, which.one = btemps2) #Error not an S4 object


head(cc_score)
cc_score
nrow(cc_score)

#cc_peak <- findPeaks(cc_score, frame = 1, parallel = F) #nicht notwendig
#str(cc_peak)
#cc_peak
#plot(cc_peak, hit.marker = "points")

#writeBinTemplates(btemps2, dir = "", ext = "bt", parallel = FALSE)
#showPeaks(detection.obj = resq_peak, which.one = "#", flim = c(1.5, 8), point = TRUE, scorelim = c(3, 5))
