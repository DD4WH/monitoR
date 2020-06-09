######################################
#
# Auto - ID
# Eurasian Pygmy Owl
#
# (c) Frank Dziock, 08.06.2020
#
# GNU GPLv3
#
######################################

library(monitoR)
library(tuneR)
library(warbleR)
library(bioacoustics)
library(seewave)

#################################################

Training_dir <- "f:/Lehre/11_SS2020/AutoID Sperlingskauz/github/Training"

Classification_dir <- "f:/Lehre/11_SS2020/AutoID Sperlingskauz/github/Classification"

######### RUN ONLY ONCE #############################
# conversion from MP3 to WAV
setwd(Training_dir)
mp32wav()

# resampling to 48ksps sample rate
T1.fp <- file.path(Training_dir, "XC506423.wav") # file from xenocanto database
T2.fp <- file.path(Training_dir, "XC535971.wav") # file from xenocanto database
WAV1 <- readWave(T1.fp)
WAV2 <- readWave(T2.fp)
WAV1 <- resample(WAV1, 48000)
WAV2 <- resample(WAV2, 48000)
savewav(WAV1, 48000, filename="T1.wav")
savewav(WAV2, 48000, filename="T2.wav")
######### END of RUN ONLY ONCE #############################

##### TEMPLATE LIST CREATION ##########
T1.fp <- file.path(Training_dir, "T1.wav")
T2.fp <- file.path(Training_dir, "T2.wav")
T4.fp <- file.path(Training_dir, "T4.wav") # one of my own recordings

Template1 <- makeBinTemplate(T1.fp, amp.cutoff = -18, score.cutoff = 3, t.lim = c(2, 6),
                         frq.lim = c(0.7, 2.4), buffer = 2, name = "t1", wl=1024)
Template2 <- makeBinTemplate(T2.fp, amp.cutoff = -18, score.cutoff = 3, t.lim = c(5, 9),
                             frq.lim = c(1, 3.2), buffer = 1, name = "t2", wl=512)
Template4 <- makeBinTemplate(T4.fp, amp.cutoff = -32, score.cutoff = 3, t.lim = c(6, 8),
                             frq.lim = c(1.2, 1.8), buffer = 1, name = "t4", wl=512)

TemplateCombi <- combineBinTemplates(Template1, Template2, Template4)

##### END of TEMPLATE CREATION ##########


##### NOW USE the created template list for classification of unknown files #######

time_start <- Sys.time()
setwd(Classification_dir)

Scores <- batchBinMatch(dir.survey= Classification_dir, 
                        ext.survey= "wav", templates= TemplateCombi, parallel = FALSE, show.prog = TRUE, 
                        warn = FALSE) 
write.csv2(Scores, file = "Sperlingskauz_ID_scores.csv")

SK_IDscores=aggregate(Scores$score,by=list(Scores$id),FUN=max)

write.csv2(SK_IDscores, file = "Sperlingskauz_ID_scores_agg.csv")

time_end <- Sys.time()

time_end - time_start

###### END of CLASSIFICATION ######


