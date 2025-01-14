
# SPATIAL AND TEMPORAL VARIABILITY OF STEM EMISSIONS    (created by jbarba at 09072018)
## This script contents all data processing, analyses and plotting for stem emissions necessary for the hole study manuscript (except the direct calculations from SoilFluxPro)


# Libraries
library(doBy)
library(ggplot2)
library(grid)
library(gridExtra)
library(nlme)
library(lme4)
library(dplyr)


# Directories
wd <- 'C:/Users/barbafej/Dropbox/SJ_stem_fluxes/SJ_studies/SJ_full_paper/txt/' # working directory
out <- '//anr.udel.edu/files/shares/jbarba/My Documents/SJ_Data/SJ_stem_fluxes/SJ_full_paper/Figures/'  # output directory
setwd(wd)


# 1. Figures ----
  # Figure 1. Manual stem CO2 emissions ----
  
  fluxes<-read.table("Manual_fluxes.txt", fill=TRUE,header=TRUE,sep="\t",na.strings=c("NA","#N/A!","#N/A","#NA!"))
  
  #CO2 flux for each tree and stem height with the adjusted scales for each tree
  CO2_flux_tree_free<-ggplot(fluxes, aes(x=DOY, y=CO2_flux)) +
    geom_line(aes(color=as.factor(Location))) +
    geom_point(aes(color=as.factor(Location),shape=as.factor(Location))) +
    scale_color_brewer(palette="Dark2", labels = c("50cm","100cm","150cm"), name="Stem height") +  #Colors displayed for this palette: #1b9e77 for green, #d95f02 for orange and #7570b3 for purple
    scale_shape(labels=c("50cm","100cm","150cm"), name="Stem height") +
    geom_hline(yintercept = 0, linetype=2, size=0.5) +
    facet_wrap(~Tree, scales="free") +
    xlab("DOY") + 
    ylab(bquote('CO'[2]~ 'flux  ('*mu~ 'mol' ~CO[2]~ m^-2~s^-1*')')) +
    theme(axis.text.x = element_text(colour = "grey20", size = 12, angle = 90, hjust = 0.5, vjust = 0.5),
          axis.text.y = element_text(colour = "grey20", size = 12),
          text = element_text(size = 16)) +
    theme_bw() +
    theme(panel.grid = element_blank()) +
    theme(legend.position = c(1, 0),
          legend.justification = c(1.5, -0.2),
          legend.title = element_text(face =2),
          legend.text=element_text(size=12),
          axis.title=element_text(size=12),
          axis.text = element_text(color = "black", size=10)) +
    guides(color = guide_legend(reverse = TRUE), shape = guide_legend(reverse = TRUE)) 
  
  ggsave(file="CO2_manual_free.png", CO2_flux_tree_free, width=20, height=17, dpi=600, units='cm', device='png', path=out)
  #ggsave(file="CO2_manual_free.tiff", CO2_flux_tree_free, width=20, height=17, dpi=600, units='cm', device='tiff', path=out)

  
  
  # Figure 2. Automated stem emissions (CO2 & CH4) ----
  
  stem_d<-read.table('SJ_continuous_stem_emissions_daily.txt', fill=TRUE,header=TRUE,sep="\t",na.strings=c("NA","#N/A!","#N/A","#NA!"))
  
  
  CO2_cont_1<-ggplot(subset(stem_d,code=="Stem"&Tree=="1"), aes(DOY, CO2, col=as.factor(Port), shape=as.factor(Port))) +
    geom_ribbon(aes(ymin = CO2 - CO2sd, ymax = CO2 + CO2sd, fill=as.factor(Port)), alpha=0.4, colour=NA) +
    scale_fill_manual(values=c("#1b9e77","#7570b3")) +
    geom_point(na.rm=TRUE, size=0.7) +
    geom_line(na.rm=TRUE, size=0.5) +
    scale_color_manual(values=c("#1b9e77","#7570b3")) + 
    geom_hline(yintercept = 0, linetype=2, size=0.5) +
    ylim(-2,12.5) +
    annotate("text", x = 285, y = 12, label = sprintf('\u25B2'), col="#7570b3", size=3) +
    annotate("text", x = 285, y = 10.5, label = sprintf('\u25CF'), col="#1b9e77", size=4) +
    ylab(bquote('CO'[2]~ 'flux  ('*mu~ 'mol' ~CO[2]~ m^-2~s^-1*')')) +
    annotate("text", x=320, y=12, label= "150 cm",color="#7570b3",size=4, fontface =2) +
    annotate("text", x=320, y=10.5, label= "50 cm",color="#1b9e77",size=4, fontface =2) +
    annotate("text", x=103, y=12, label= "a)",size=4.5, fontface =2) +
    annotate("text", x=225, y=12, label= "Tree 1",size=4.5, fontface =2) +
    theme_bw() + theme(panel.grid = element_blank()) +
    theme(legend.position="none",
          axis.title=element_text(size=12),
          axis.text = element_text(color = "black", size=12))
  
  CO2_cont_2<-ggplot(subset(stem_d,code=="Stem"&Tree=="2"), aes(DOY, CO2, col=as.factor(Port), shape=as.factor(Port))) +
    geom_ribbon(aes(ymin = CO2 - CO2sd, ymax = CO2 + CO2sd, fill=as.factor(Port)), alpha=0.4, colour=NA) +
    scale_fill_manual(values=c("#1b9e77","#7570b3")) +
    geom_point(na.rm=TRUE, size=0.7) +
    geom_line(na.rm=TRUE, size=0.5) +
    scale_color_manual(values=c("#1b9e77","#7570b3")) +  
    geom_hline(yintercept = 0, linetype=2, size=0.5) +
    ylim(-2,12.5) +
    ylab(bquote('CO'[2]~ 'flux  ('*mu~ 'mol' ~CO[2]~ m^-2~s^-1*')')) +
    annotate("text", x=103, y=12, label= "c)",size=4.5, fontface =2) +
    annotate("text", x=225, y=12, label= "Tree 2",size=4.5, fontface =2) +
    theme_bw() + theme(panel.grid = element_blank()) +
    theme(legend.position="none",
          axis.title=element_text(size=12),
          axis.text = element_text(color = "black", size=12))
  
  CO2_cont_3<-ggplot(subset(stem_d,code=="Stem"&Tree=="3"), aes(DOY, CO2, col=as.factor(Port), shape=as.factor(Port))) +
    geom_ribbon(aes(ymin = CO2 - CO2sd, ymax = CO2 + CO2sd, fill=as.factor(Port)), alpha=0.4, colour=NA) +
    scale_fill_manual(values=c("#1b9e77","#7570b3")) +
    geom_point(na.rm=TRUE, size=0.7) +
    geom_line(na.rm=TRUE, size=0.5) +
    scale_color_manual(values=c("#1b9e77","#7570b3")) +  
    geom_hline(yintercept = 0, linetype=2, size=0.5) +
    ylim(-2,12.5) +
    ylab(bquote('CO'[2]~ 'flux  ('*mu~ 'mol' ~CO[2]~ m^-2~s^-1*')')) +
    annotate("text", x=103, y=12, label= "e)",size=4.5, fontface =2) +
    annotate("text", x=225, y=12, label= "Tree 3",size=4.5, fontface =2) +
    theme_bw() + theme(panel.grid = element_blank()) +
    theme(legend.position="none",
          axis.title=element_text(size=12),
          axis.text = element_text(color = "black", size=12)) 
  
  
  #Upper CH4 fluxes for tree 1 are so hight that it is hard to see seasonal patterns for Lower stem if both are plotted together
  #If we want to plot both chambers in different scales or using secondary axes, we will need the next chunk of script.
  
  for (i in 1:length(stem_d$Date)){
    if(stem_d$Port[i]==2) {
      stem_d$Lower_tree_1[i]<-stem_d$CH4[i] 
      stem_d$Lower_tree_1sd[i]<-stem_d$CH4sd[i]
    }
    else{
      stem_d$Lower_tree_1[i]<-NA 
      stem_d$Lower_tree_1sd[i]<-NA
    }
    if(stem_d$Port[i]==3) {
      stem_d$Upper_tree_1[i]<-stem_d$CH4[i]
      stem_d$Upper_tree_1sd[i]<-stem_d$CH4sd[i]
    }
    else{
      stem_d$Upper_tree_1[i]<-NA 
      stem_d$Upper_tree_1sd[i]<-NA
    }
    if(stem_d$Port[i]!=3) {
      stem_d$Other[i]<-stem_d$CH4[i]
      stem_d$Othersd[i]<-stem_d$CH4sd[i]
    }
    else{
      stem_d$Other[i]<-NA 
      stem_d$Othersd[i]<-NA
    }
  }
  
  CH4_cont_1<-ggplot(subset(stem_d,code=="Stem"&Tree=="1"), aes(DOY, CH4, col=as.factor(Port), shape=as.factor(Port))) +
    geom_ribbon(aes(ymin = CH4 - CH4sd, ymax = CH4 + CH4sd, fill=as.factor(Port)), alpha=0.4, colour=NA) +
    scale_fill_manual(values=c("#1b9e77","#7570b3")) +
    geom_point(na.rm=TRUE, size=0.7) +
    geom_line(na.rm=TRUE, size=0.5) +
    scale_color_manual(values=c("#1b9e77","#7570b3")) + 
    geom_hline(yintercept = 0, linetype=2, size=0.5) +
    ylab(bquote('CH'[4]~ 'flux  (nmol ' ~CH[4]~ m^-2~s^-1*')')) +
    annotate("text", x=103, y=36, label= "b)",size=4.5, fontface =2) +
    annotate("text", x=225, y=36, label= "Tree 1",size=4.5, fontface =2) +
    theme_bw() + theme(panel.grid = element_blank()) +
    theme(legend.position="none",
          axis.title=element_text(size=12),
          axis.text = element_text(color = "black", size=12))    
  
  CH4_cont_2<-ggplot(subset(stem_d,code=="Stem"&Tree=="2"), aes(DOY, CH4, col=as.factor(Port), shape=as.factor(Port))) +
    geom_ribbon(aes(ymin = CH4 - CH4sd, ymax = CH4 + CH4sd, fill=as.factor(Port)), alpha=0.4, colour=NA) +
    scale_fill_manual(values=c("#1b9e77","#7570b3")) +
    geom_point(na.rm=TRUE, size=0.7) +
    geom_line(na.rm=TRUE, size=0.5) +
    scale_color_manual(values=c("#1b9e77","#7570b3")) + 
    geom_hline(yintercept = 0, linetype=2, size=0.5) +
    ylim(-2,4) +
    #xlab("Date") + 
    ylab(bquote('CH'[4]~ 'flux  (nmol ' ~CH[4]~ m^-2~s^-1*')')) +
    annotate("text", x=103, y=3.8, label= "d)",size=4.5, fontface =2) +
    annotate("text", x=225, y=3.8, label= "Tree 2",size=4.5, fontface =2) +
    theme_bw() + theme(panel.grid = element_blank()) +
    theme(legend.position="none",
          axis.title=element_text(size=12),
          axis.text = element_text(color = "black", size=12))    
  
  CH4_cont_3<-ggplot(subset(stem_d,code=="Stem"&Tree=="3"), aes(DOY, CH4, col=as.factor(Port), shape=as.factor(Port))) +
    geom_ribbon(aes(ymin = CH4 - CH4sd, ymax = CH4 + CH4sd, fill=as.factor(Port)), alpha=0.4, colour=NA) +
    scale_fill_manual(values=c("#1b9e77","#7570b3")) +
    geom_point(na.rm=TRUE, size=0.7) +
    geom_line(na.rm=TRUE, size=0.5) +
    scale_color_manual(values=c("#1b9e77","#7570b3")) +  
    geom_hline(yintercept = 0, linetype=2, size=0.5) +
    ylim(-2,4) +
    ylab(bquote('CH'[4]~ 'flux  (nmol ' ~CH[4]~ m^-2~s^-1*')')) +
    annotate("text", x=103, y=3.8, label= "f)",size=4.5, fontface =2) +
    annotate("text", x=225, y=3.8, label= "Tree 3",size=4.5, fontface =2) +
    theme_bw() + theme(panel.grid = element_blank()) +
    theme(legend.position="none",
          axis.title=element_text(size=12),
          axis.text = element_text(color = "black", size=12))   
  
  CO2_CH4_cont <- grid.arrange(CO2_cont_1, CH4_cont_1, CO2_cont_2, CH4_cont_2, CO2_cont_3, CH4_cont_3, ncol=2)
  
  ggsave(file="GHG_cont_time_series.png", CO2_CH4_cont, width=20, height=20, dpi=600, units='cm', device='png', path=out)
  #ggsave(file="GHG_cont_time_series.tiff", CO2_CH4_cont, width=20, height=20, dpi=600, units='cm', device='tiff', path=out)
  
  
  
  # Figure 3. Manual stem CH4 emissions ----
  
  
  
  #CH4 flux for each tree and stem height with the adjusted scales for each tree
  CH4_flux_tree_free<-ggplot(fluxes, aes(x=DOY, y=CH4_flux)) +
    geom_line(aes(color=as.factor(Location))) +
    geom_point(aes(color=as.factor(Location),shape=as.factor(Location))) +
    scale_color_brewer(palette="Dark2", labels = c("50cm","100cm","150cm"), name="Stem height") +  #Colors displayed for this palette: #1b9e77 for green, #d95f02 for orange and #7570b3 for purple
    scale_shape(labels=c("50cm","100cm","150cm"), name="Stem height") +
    geom_hline(yintercept = 0, linetype=2, size=0.5) +
    facet_wrap(~Tree, scales="free") +
    xlab("DOY") + 
    ylab(bquote('CH'[4]~ 'flux  (nmol ' ~CH[4]~ m^-2~s^-1*')')) +
    theme(axis.text.x = element_text(colour = "grey20", size = 12, angle = 90, hjust = 0.5, vjust = 0.5),
          axis.text.y = element_text(colour = "grey20", size = 12),
          text = element_text(size = 16)) +
    theme_bw() +
    theme(panel.grid = element_blank()) +
    theme(legend.position = c(1, 0),
          legend.justification = c(1.5, -0.2),
          legend.title = element_text(face =2),
          legend.text=element_text(size=12),
          axis.title=element_text(size=12),
          axis.text = element_text(color = "black", size=10)) +
    guides(color = guide_legend(reverse = TRUE), shape = guide_legend(reverse = TRUE)) 
  
  ggsave(file="CH4_manual_free.png", CH4_flux_tree_free, width=20, height=17, dpi=600, units='cm', device='png', path=out)
  #ggsave(file="CH4_manual_free.tiff", CH4_flux_tree_free, width=20, height=17, dpi=600, units='cm', device='tiff', path=out)
  
  
  
  
  # Figure 4. Stem and soil CO2 and CH4 concentrations ----
    # 4.1 a & b Stem concentrations ----  
    
    ## ggplot2, doBy grifExtra are required for running this chunk
    Stem_c<-read.table("SJ_stem_concentrations.txt", fill=TRUE,header=TRUE,sep="\t",na.strings=c("NA","#N/A!","#N/A","#NA!"))
    Stem_c$Location <- factor(Stem_c$Location, ordered = TRUE, levels = c("1", "2", "3"))    
    Stem_c$CH4t<-log10(Stem_c$CH4)
    Stem_c$CO2t<-log10(Stem_c$CO2)
    Stem_c$code<-paste0(Stem_c$Tree,Stem_c$Location)
    Stem_c[46,2]<-"1"
    Stem_c[48,2]<-"1"
    Stem_c[50,2]<-"1"
    
    # This is an ANOVA with repeated measures (Tree as an error factor) for testing differences between Heights  
    modelAOV <- aov(CH4t~Location+Error(factor(Tree)), data = Stem_c)
    summary(modelAOV)
    model_CO2_lm <- nlme::lme(CO2t~Location,random=~1|Tree,data=Stem_c)
    summary(model_CO2_lm)
    anova(model_CO2_lm)
    plot(model_CO2_lm)
    
    model_CH4_lm <- nlme::lme(CH4t~Location,random=~1|Tree,data=Stem_c)
    summary(model_CH4_lm)
    anova(model_CH4_lm)
    plot(model_CH4_lm)
    
    modelAOV <- aov(CO2t~Location+Error(factor(Tree)), data = Stem_c)
    summary(modelAOV)
    
    ## Plot [CH4] and [CO2] at 08/20/2018
    
    Stem_c$std_height<-as.numeric(Stem_c$Location)*50
    
    Stem_c$Location<-as.factor(Stem_c$Location)
    
    CO2_axis <- c("10^3", "10^4", "10^5")
    levels(CO2_axis) <- c("10^3", "10^4", "10^5")
    
    CO2_stem_concentration<-ggplot(Stem_c, aes(x=std_height, y=CO2t, fill=factor(std_height))) +
      geom_violin(trim=F) +
      geom_point() +
      scale_fill_brewer(palette="Dark2") +
      scale_x_continuous(limits=c(5,180), breaks=c(0, 50, 100, 150)) + 
      scale_y_continuous(position="right", limits=c(2.5,5.5), breaks=c(3,4,5), labels=parse(text = levels(CO2_axis))) + 
      coord_flip() +
      annotate("text", x=15, y=5.3, label= "a)",size=4.5, fontface =2) +
      xlab('Stem Height (cm)') + 
      ylab('[CO'[2]~']  (ppmv) (log scale)') +
      theme_bw() + theme(panel.grid = element_blank()) +
      theme(legend.position="none",
            axis.title=element_text(size=12),
            axis.text = element_text(color = "black", size=12),
            plot.margin=unit(c(0.2,0,0.2,0.2), "cm"))
    
    CH4_axis <- c("10[-2]","1", "10[2]", "10[4]", "10[6]")
    levels(CH4_axis) <- c("10^-2","1", "10^2", "10^4", "10^6")
    
    CH4_stem_concentration<-ggplot(Stem_c, aes(x=std_height, y=CH4t, fill=factor(std_height))) +
      geom_violin(trim=F) +
      geom_point() +
      scale_fill_brewer(palette="Dark2") +  #Colors displayed for this palette: #1b9e77 for green, #d95f02 for orange and #7570b3 for purple
      scale_x_continuous(limits=c(5,180), breaks=c(0, 50, 100, 150)) + 
      scale_y_continuous(position="right", breaks=c(-2,0,2,4,6), labels=parse(text = levels(CH4_axis))) + 
      coord_flip() +
      annotate("text", x=15, y=6.8, label= "b)",size=4.5, fontface =2) +
      xlab('Stem Height (cm)')  +
      ylab('[CH'[4]~'] (ppmv) (log scale)') +
      theme_bw() + theme(panel.grid = element_blank()) +
      theme(legend.position="none",
            axis.title.x=element_text(size=12),
            axis.title.y=element_blank(),
            axis.text.x = element_text(color = "black", size=12),
            axis.text.y = element_blank(),
            axis.ticks.y=element_blank(),
            plot.margin=unit(c(0.2,0.2,0.2,-0.1), "cm"))
    
    stem_concentrations <- grid.arrange(CO2_stem_concentration,CH4_stem_concentration, nrow=1) 
    ggsave(file="Stem_concentrations.png", stem_concentrations, width=16, height=10, dpi=600, units='cm', device='png', path=out)
  #  ggsave(file="Stem_concentrations.tiff", stem_concentrations, width=16, height=10, dpi=600, units='cm', device='tiff', path=out)
  #  ggsave(file="Stem_concentrations.svg", plot=stem_concentrations, width=16, height=10, units='cm', path=out)
  
    # 4.2 c & d Soil concentrations ----
    
    Soil_concentrations<-read.table("SJ_soil_concentrations.txt", fill=TRUE,header=TRUE,sep="\t",na.strings=c("NA","#N/A!","#N/A","#NA!"))
    Soil_concentrations<-na.omit(Soil_concentrations)
    
    Soil_c<-summaryBy(CH4 + CO2 ~ Date + Depth, data=Soil_concentrations,FUN=c(mean,sd), na.rm=TRUE)
    
    ## Plot [CH4] and [CO2] measured on 10/06/2017, 08/20/2018 and 02/31/2019
    
    CO2_soil<-ggplot(data=Soil_c, aes(x=Depth, y=CO2.mean, color=as.factor(Date))) +
      geom_point(data=Soil_concentrations, aes(x=Depth, y=CO2, color=as.factor(Date)), size=1.5) +
      geom_line(na.rm=TRUE, size=0.75) +
      scale_color_manual(values=c("#e41a1c","#377eb8","#4daf4a")) +
      scale_x_reverse(limits = c(160, -3),breaks = c(0, 10, 25, 50, 75, 100, 150), label = c("0", "10", "25", "50", "75", "100", "GW")) +
      scale_y_continuous(position = "left", limits=c(0,12500)) +
      coord_flip() +
      geom_hline(yintercept = Soil_c[8,4], linetype=2, size=0.5) +
      xlab('Soil depth (cm)') + 
      ylab('[CO'[2]~']  (ppmv)') +
      annotate("text", x=0, y=11750, label= "c)",size=4.5, fontface =2) +
      annotate("text", x=120, y=10000, label= "October 2017",size=4, fontface =2, color="#4daf4a") +
      annotate("text", x=135, y=10000, label= "August 2018",size=4, fontface =2, color="#377eb8") +
      annotate("text", x=150, y=10000, label= "March 2019",size=4, fontface =2, color="#e41a1c") +
      theme_bw() + theme(panel.grid = element_blank()) +
      theme(legend.position="none",
            axis.title.x=element_text(size=12),
            axis.title.y=element_blank(),
            axis.text.x = element_text(color = "black", size=12),
            axis.text.y = element_blank(),
            axis.ticks.y=element_blank(),
            plot.margin=unit(c(0.2,0,0.2,0.2), "cm"))
      
    
    CH4_soil<-ggplot(data=Soil_c, aes(x=Depth, y=CH4.mean, color=as.factor(Date))) +
      geom_point(data=Soil_concentrations, aes(x=Depth, y=CH4, color=as.factor(Date)), size=1.5) +
      geom_line(na.rm=TRUE, size=0.75) +
      scale_color_manual(values=c("#e41a1c","#377eb8","#4daf4a")) +
      scale_x_reverse(position = "top", limits = c(160, -3),breaks = c(0, 10, 25, 50, 75, 100, 150), label = c("0", "10", "25", "50", "75", "100", "GW")) +
      scale_y_continuous(position = "left", limits=c(-0.1,5.3)) +
      coord_flip() +
      geom_hline(yintercept = Soil_c[8,3], linetype=2, size=0.5) +
      xlab('Soil depth (cm)') + 
      ylab('[CH'[4]~']  (ppmv)') +
      annotate("text", x=0, y=5, label= "d)",size=4.5, fontface =2) +
      theme_bw() + theme(panel.grid = element_blank()) +
      theme(legend.position="none",
            axis.title=element_text(size=12),
            axis.text = element_text(color = "black", size=12),
            plot.margin=unit(c(0.2,0.2,0.2,-0.1), "cm")) 
    
    soil_concentrations<-grid.arrange(CO2_soil, CH4_soil, ncol=2)
    ggsave(file="Soil_concentrations.png", soil_concentrations, width=16, height=10, dpi=600, units='cm', device='png', path=out)
  #  ggsave(file="Soil_concentrations.tiff", soil_concentrations, width=16, height=10, dpi=600, units='cm', device='tiff', path=out)
  #  ggsave(file="Soil_concentrations.svg", plot=soil_concentrations, width=16, height=10, units='cm', path=out)
    
  
  # Figure 5. Tree cores incubation ----
  
  incubations<-read.table("SJ_cores_incubations.txt", fill=TRUE,header=TRUE,sep="\t",na.strings=c("NA","#N/A!","#N/A","#NA!"))
  
  # Shapiro-Wilk normality test for Heartwood
  with(incubations, shapiro.test(log(CO2[Tissue == "Heartwood"])))
  # Shapiro-Wilk normality test for Sapwood
  with(incubations, shapiro.test(log(CO2[Tissue == "Sapwood"]))) 
  #Shapiro test indicates that Heartwood and Sapwood data are normally distributed (p>0.05)
  var.test(log(CO2) ~ Tissue, data = incubations)
  #The p-value of F-test is p < 0.001. It's smaller than the significance level alpha = 0.05, so there are differences between the variances of the two sets of data. 
  #Therefore, we cannot use the classic t-test witch assume equality of the two variances.
  
  t.test(CO2 ~ Tissue, data=incubations, alternative="greater", var.equal = FALSE)
  
  
  # Shapiro-Wilk normality test for Heartwood
  with(incubations, shapiro.test(CH4[Tissue == "Heartwood"]))
  # Shapiro-Wilk normality test for Sapwood
  with(incubations, shapiro.test(CH4[Tissue == "Sapwood"])) 
  #Shapiro test indicates that Heartwood and Sapwood data are normally distributed (p>0.05)
  var.test(CH4 ~ Tissue, data = incubations)
  #The p-value of F-test is p = 0.1171. It's greater than the significance level alpha = 0.05. 
  #In conclusion, there is no significant difference between the variances of the two sets of data. 
  #Therefore, we can use the classic t-test witch assume equality of the two variances.
  
  t.test(CH4 ~ Tissue, data=incubations, alternative="greater", var.equal = FALSE)
  
  incubations$Tree<- stringr::str_sub(incubations$Sample,1,1)
  incubations$Location<- stringr::str_sub(incubations$Sample,2,2) 
  
  model.ch4.1<- nlme::lme(CH4 ~ Tissue*Location, data=incubations,random=~1|Tree)
  summary(model.ch4.1)
  plot(model.ch4.1)
  anova(model.ch4.1)
  
  model.ch4.2<- nlme::lme(CH4 ~ Tissue, data=incubations,random=~1|Tree/Location)
  summary(model.ch4.2)
  plot(model.ch4.2)
  anova(model.ch4.2)
  
  model.ch4.3<- nlme::lme(CH4 ~ Tree*Tissue, data=incubations,random=~1|Location)
  summary(model.ch4.3)
  plot(model.ch4.3)
  anova(model.ch4.3)
  
  inc_CO2<-ggplot(incubations, aes(x=Tissue, y=CO2, fill=factor(Tissue))) +
    geom_violin(trim=F) +
    scale_fill_manual(values=c("#fc8d59","#91cf60")) +
    geom_point(size=0.9) +
    ylab('CO'[2]~' (ppmv)') +
    annotate("text", x=2.35, y=1075, label= "a)",size=4.5, fontface =2) +
    annotate("text", x=1.5, y=975, label= "***",size=6, fontface =2) +
    theme_bw() + theme(panel.grid = element_blank()) +
    theme(legend.position="none",
          axis.text.x=element_blank(),
          axis.title=element_text(size=13),
          axis.title.x=element_blank(),
          axis.text.y = element_text(color = "black", size=12),
          plot.margin=unit(c(0.2,0.2,0.2,0.2), "cm")) 
  
  inc_CH4<-ggplot(incubations, aes(x=Tissue, y=CH4, fill=factor(Tissue))) +
    geom_violin(trim=F) +
    scale_fill_manual(values=c("#fc8d59","#91cf60")) +
    geom_point(size=0.9) +
    ylab('CH'[4]~' (ppmv)') +
    scale_y_continuous(limits=c(180,330), breaks=c(175,225,275,325)) + 
    annotate("text", x=2.35, y=325, label= "b)",size=4.5, fontface =2) +
    annotate("text", x=1.5, y=315, label= "***",size=6, fontface =2) +
    theme_bw() + theme(panel.grid = element_blank()) +
    theme(legend.position="none",
          axis.text.x=element_text(color = "black", size=13),
          axis.title=element_text(size=13),
          axis.title.x=element_blank(),
          axis.text.y = element_text(color = "black", size=12),
          plot.margin=unit(c(-0.3,0.2,0.2,0.2), "cm"))
  
  inc <- grid.arrange(inc_CO2,inc_CH4, ncol=1) 
  ggsave(file="Core_incubations.png", inc, width=8, height=16, dpi=600, units='cm', device='png', path=out)
  #ggsave(file="Core_incubations.tiff", inc, width=8, height=16, dpi=600, units='cm', device='tiff', path=out)

  
  

# 2. Data analysis -----   

  
fluxes<-read.table("Manual_fluxes.txt", fill=TRUE,header=TRUE,sep="\t",na.strings=c("NA","#N/A!","#N/A","#NA!"))
fluxes.cont<-read.table("SJ_continuous_stem_emissions_daily.txt", fill=TRUE,header=TRUE,sep="\t",na.strings=c("NA","#N/A!","#N/A","#NA!"))


# Data preparation    
fluxes$Location <- factor(fluxes$Location, ordered = TRUE, levels = c("1", "2", "3"))
fluxes$Locationf <- factor(fluxes$Location)
fluxes<-subset(fluxes,CH4_flux<10) # There is one CH4 manual measurement with a very high value, which is clearly a statistical outlier. 

fluxes.cont$Port<-as.factor(fluxes.cont$Port)
fluxes.cont$Tree<-as.factor(fluxes.cont$Tree)
fluxes.cont<-subset(fluxes.cont, fluxes.cont$code=="Stem")
fluxes.cont$Locationf <-factor(fluxes.cont$Location)
fluxes.cont$Location <- factor(fluxes.cont$Location, ordered = TRUE, levels = c("2", "3"))


# Box-cox transformation of CH4
fluxes$CH4_flux_bc <- car::bcnPower(fluxes$CH4_flux,
                                    lambda=car::powerTransform(fluxes$CH4_flux,family='bcnPower')[['lambda']],
                                    gamma=car::powerTransform(fluxes$CH4_flux,family='bcnPower')[['gamma']])  
fluxes$CH4_flux_bc_z <- scale(fluxes$CH4_flux_bc,scale=TRUE)
fluxes$Temp_z <- scale(fluxes$Temp,scale=TRUE)
fluxes$VWC_z <- scale(fluxes$VWC,scale=TRUE)
fluxes$Diam_z <- scale(fluxes$Diam,scale=TRUE)
fluxes$Temp_c <- scale(fluxes$Temp,scale=FALSE)
fluxes$VWC_c <- scale(fluxes$VWC,scale=FALSE)
fluxes$Diam_c <- scale(fluxes$Diam,scale=FALSE)

fluxes.cont$CH4_bc <- car::bcnPower(fluxes.cont$CH4,
                                    lambda=car::powerTransform(fluxes.cont$CH4,family='bcnPower')[['lambda']],
                                    gamma=car::powerTransform(fluxes.cont$CH4,family='bcnPower')[['gamma']])
fluxes.cont$CH4_bc_z = scale(fluxes.cont$CH4_bc,scale=TRUE)
fluxes.cont$Temp_z = scale(fluxes.cont$Temp,scale=TRUE)
fluxes.cont$SWC_z = scale(fluxes.cont$SWC,scale=TRUE)
fluxes.cont$Temp_c = scale(fluxes.cont$Temp,scale=FALSE)
fluxes.cont$SWC_c = scale(fluxes.cont$SWC,scale=FALSE)

  #2.1) Manual measurements of CO2 stem emissions ----       
  
  # model without temporal autocorrelation
  lmm_co2_lme<- lme(log(CO2_flux)~Temp*Location+VWC*Location+Diam,
                    random=~Temp|Tree,data=fluxes)
  # model with temporal autocorrelation
  lmm_co2_AR1 <- update(lmm_co2_lme,cor=corAR1(form=~1|Tree/Location))
  
  anova(lmm_co2_lme,lmm_co2_AR1)
  
  par(mfcol=c(1,2))
  acf(residuals(lmm_co2_lme,type='normalized'))
  acf(residuals(lmm_co2_AR1,type='normalized'))
  
  plot(lmm_co2_AR1)
  summary(lmm_co2_AR1)
  MuMIn::r.squaredGLMM(lmm_co2_AR1)
  car::Anova(lmm_co2_AR1,3)
  
  #2.2) Manual measurements of CH4 stem emissions ----  
  
  # untransformed ch4 flux
  lmm_ch4_lme<- lme(CH4_flux~Temp*Location+VWC*Location+Diam,
                    random=~1|Tree,data=fluxes)
  plot(lmm_ch4_lme) #residuals don't look good
  
  # use box-cox transformed ch4 flux
  lmm_ch4bc_lme<- lme(CH4_flux_bc~Temp*Location+VWC*Location+Diam,
                      random=~1|Tree,data=fluxes)
  plot(lmm_ch4bc_lme)
  
  # add corAR1
  lmm_ch4bc_AR1 <- update(lmm_ch4bc_lme,
                          cor=corAR1(form=~DOY|Tree/Location))
  plot(lmm_ch4bc_AR1)
  anova(lmm_ch4bc_lme,lmm_ch4bc_AR1)
  
  par(mfcol=c(1,2))
  acf(residuals(lmm_ch4bc_lme,type='normalized'))
  acf(residuals(lmm_ch4bc_AR1,type='normalized'))
  
  plot(lmm_ch4bc_AR1)
  summary(lmm_ch4bc_AR1)
  MuMIn::r.squaredGLMM(lmm_ch4bc_AR1)
  car::Anova(lmm_ch4bc_AR1,3)
  
  #2.3) Automated CO2 measurements ----
  
  # model without temporal autocorrelation
  co2.lme <- lme(log(CO2)~Temp*Locationf*SWC, random= ~Temp|Tree,
                 na.action=na.omit,data=fluxes.cont)
  
  # model with temporal autocorrelation
  co2.lme.AR1 <- update(co2.lme,cor=corAR1(form=~DOY|Tree/Locationf))
  
  par(mfcol=c(1,2))
  acf(residuals(co2.lme,type='normalized'))
  acf(residuals(co2.lme.AR1,type='normalized'))
  
  plot(co2.lme.AR1)
  summary(co2.lme.AR1)
  MuMIn::r.squaredGLMM(co2.lme.AR1)
  car::Anova(co2.lme.AR1,3)
  
  cowplot::plot_grid(nrow=2,
                     sjPlot::plot_model(co2.lme.AR1,type='pred',terms=c('SWC','Locationf')),
                     sjPlot::plot_model(co2.lme.AR1,type='pred',terms=c('Temp','Locationf'))
  )
  
  #2.4) Automated CH4 measurements ----
  # model without temporal autocorrelation
  ch4bc.lme<- lme(CH4_bc~Temp*Locationf*SWC, random= ~Temp|Tree,
                  data=fluxes.cont,na.action=na.omit)
  
  # model variance as a function of Tree to consider heteroscedasticity
  ch4bc.lme.varIdent<- lme(CH4_bc~Temp*Locationf*SWC, random= ~Temp|Tree,
                           weights=varIdent(form=~1|Tree),
                           data=fluxes.cont,na.action=na.omit)
  # Add corAR1
  ch4bc.lme.varIdentAR1<- update(ch4bc.lme.varIdent,cor=corAR1(form=~DOY|Tree/Locationf))
  
  par(mfcol=c(1,2))
  acf(residuals(ch4bc.lme.varIdent,type='normalized'))
  acf(residuals(ch4bc.lme.varIdentAR1,type='normalized'))
  
  anova(ch4bc.lme.varIdent,ch4bc.lme.varIdentAR1)
  
  plot(ch4bc.lme.varIdentAR1)
  summary(ch4bc.lme.varIdentAR1)
  MuMIn::r.squaredGLMM(ch4bc.lme.varIdentAR1)
  car::Anova(ch4bc.lme.varIdentAR1,3)
  
  sjPlot::plot_model(ch4bc.lme.varIdentAR1,type='pred',terms=c('SWC','Locationf'))
  
  
  
  
  
  # model without temporal autocorrelation
  co2.lme <- lme(log(CO2)~Temp*Location*SWC, random= ~Temp|Tree,
                 na.action=na.omit,data=fluxes.cont)
  
  # model with temporal autocorrelation
  co2.lme.AR1 <- update(co2.lme,cor=corAR1(form=~DOY|Tree/Location))
  
  anova(co2.lme,co2.lme.AR1)
  
  par(mfcol=c(1,2))
  acf(residuals(co2.lme,type='normalized'))
  acf(residuals(co2.lme.AR1,type='normalized'))
  
  plot(co2.lme.AR1)
  summary(co2.lme.AR1)
  MuMIn::r.squaredGLMM(co2.lme.AR1)
  car::Anova(co2.lme.AR1,3)
  
  #2.5) Automated CH4 measurements ----
  
  # model without temporal autocorrelation
  ch4bc.lme<- lme(CH4_bc~Temp*Location*SWC, random= ~Temp|Tree,
                  data=fluxes.cont,na.action=na.omit)
  
  # model variance as a function of Tree to consider heteroscedasticity
  ch4bc.lme.varIdent<- lme(CH4_bc~Temp*Location*SWC, random= ~Temp|Tree,
                           weights=varIdent(form=~1|Tree),
                           data=fluxes.cont,na.action=na.omit)
  # Add corAR1
  ch4bc.lme.varIdentAR1<- update(ch4bc.lme.varIdent,cor=corAR1(form=~DOY|Tree/Location))
  
  anova (ch4bc.lme.varIdent,ch4bc.lme.varIdentAR1)
  par(mfcol=c(1,2))
  acf(residuals(ch4bc.lme.varIdent,type='normalized'))
  acf(residuals(ch4bc.lme.varIdentAR1,type='normalized'))
  
  plot(ch4bc.lme.varIdentAR1)
  summary(ch4bc.lme.varIdentAR1)
  MuMIn::r.squaredGLMM(ch4bc.lme.varIdentAR1)
  anova(ch4bc.lme.varIdentAR1)




# 3. Supplementary material ----

  # Linear mixed-effects model ----
  
  # We have sapwood and heartwood density, length and moisture for tree cores sampled at 150cm. 
  # We are re-running the GLMs for manual measurements (subset 150cm fluxes) to see is there is any effect of those variables
  # These analyses will be included in the supplementary material
  
  wood<-read.table("Wood_properties.txt", fill=TRUE,header=TRUE,sep="\t",na.strings=c("NA","#N/A!","#N/A","#NA!"))
  
  # fluxes_WP is a subset of fluxes for measurements at 150 cm with the wood properties (density, length and moisture)
  fluxes_wp<-subset(fluxes,Location=="3" & Tree!="J") # I don't have wood data for tree J
  
  fluxes_wp$CH4_flux_bc <- car::bcnPower(fluxes_wp$CH4_flux,
                                         lambda=car::powerTransform(fluxes_wp$CH4_flux,family='bcnPower')[['lambda']],
                                         gamma=car::powerTransform(fluxes_wp$CH4_flux,family='bcnPower')[['gamma']])  
  fluxes_wp$CH4_flux_bc_z <- scale(fluxes_wp$CH4_flux_bc,scale=TRUE)
  fluxes_wp$Temp_z <- scale(fluxes_wp$Temp,scale=TRUE)
  fluxes_wp$VWC_z <- scale(fluxes_wp$VWC,scale=TRUE)
  fluxes_wp$Diam_z <- scale(fluxes_wp$Diam,scale=TRUE)
  fluxes_wp$Temp_c <- scale(fluxes_wp$Temp,scale=FALSE)
  fluxes_wp$VWC_c <- scale(fluxes_wp$VWC,scale=FALSE)
  fluxes_wp$Diam_c <- scale(fluxes_wp$Diam,scale=FALSE)
  
  for (t in 1:length(fluxes_wp$Date)){
    for (g in 1:length(wood$Tree_Name)){
      if (fluxes_wp$Tree[t]==wood$Tree_Name[g]) {
        fluxes_wp$Density[t]<- wood$Density[g]
        fluxes_wp$Moisture[t]<- wood$Moisture[g]
        fluxes_wp$Length_S[t]<- wood$Length_S[g]
        fluxes_wp$Moisture_H[t]<- wood$Moisture_H[g]
        fluxes_wp$Moisture_S[t]<- wood$Moisture_S[g]
      }
    }
  }
  
  lmm_co2_lme_150<- lme(log(CO2_flux)~Temp+VWC+Diam+Moisture+Density+Length_S+Moisture_S,
                        random=~1|Tree,data=fluxes_wp)
  
  # CO2 model with wood properties
  # model with temporal autocorrelation
  lmm_co2_AR1_150 <- update(lmm_co2_lme_150,cor=corAR1(form=~DOY|Tree))
  
  acf(residuals(lmm_co2_AR1_150,type='normalized'))
  
  plot(lmm_co2_AR1_150)
  summary(lmm_co2_AR1_150)
  MuMIn::r.squaredGLMM(lmm_co2_AR1_150)
  car::Anova(lmm_co2_AR1_150,3)
  
  
  # CH4 model with wood properties    
  # use box-cox transformed ch4 flux
  lmm_ch4bc_lme_150<- lme(CH4_flux_bc~Temp+VWC+Diam+Moisture+Density+Length_S+Moisture_S,
                          random=~1|Tree,data=fluxes_wp)
  
  
  # add corAR1
  lmm_ch4bc_AR1_150 <- update(lmm_ch4bc_lme_150,
                              cor=corAR1(form=~DOY|Tree))
  plot(lmm_ch4bc_AR1_150)
  anova(lmm_ch4bc_lme_150,lmm_ch4bc_AR1_150)
  
  acf(residuals(lmm_ch4bc_AR1_150,type='normalized'))
  
  plot(lmm_ch4bc_AR1_150)
  summary(lmm_ch4bc_AR1_150)
  MuMIn::r.squaredGLMM(lmm_ch4bc_AR1_150)
  car::Anova(lmm_ch4bc_AR1_150,3)
  
  
  
  # Correlation between manual CO2 and CH4 fluxes

  CH4_flux_tree_fixed<-ggplot(fluxes, aes(x=log(CO2_flux), y=CH4_flux)) +
    #geom_line() +
    geom_point() +
    geom_smooth(method='glm', span=0.1, size=1.5, na.rm=T) +
    #scale_color_brewer(palette="Dark2", labels = c("50cm","100cm","150cm"), name="Stem height") +  #Colors displayed for this palette: #1b9e77 for green, #d95f02 for orange and #7570b3 for purple
    #scale_shape(labels=c("50cm","100cm","150cm"), name="Stem height") +
    #geom_hline(yintercept = 0, linetype=2, size=0.5) +
    facet_wrap(~Tree, scales="free") +
    xlab("DOY") + 
    ylab(bquote('CH'[4]~ 'flux  (nmol ' ~CH[4]~ m^-2~s^-1*')')) +
    theme(axis.text.x = element_text(colour = "grey20", size = 12, angle = 90, hjust = 0.5, vjust = 0.5),
          axis.text.y = element_text(colour = "grey20", size = 12),
          text = element_text(size = 16)) +
    theme_bw() +
    theme(panel.grid = element_blank()) +
    theme(legend.position = c(1, 0),
          legend.justification = c(1.5, -0.2),
          legend.title = element_text(face =2),
          legend.text=element_text(size=12),
          axis.title=element_text(size=12),
          axis.text = element_text(color = "black", size=10)) +
    guides(color = guide_legend(reverse = TRUE), shape = guide_legend(reverse = TRUE)) 
  

  CH4_flux_tree_fixed<-ggplot(fluxes, aes(x=(CO2_flux), y=CH4_flux)) +
    geom_point() +
    #xlim(0,7) +
    ylim(-1,5)
  
  
  
  # Summaries
  
  Tree_A<-lm(CH4_flux~CH4_flux_bc_z, data=fluxes)
  summary(Tree_A)$adj.r.squared
  summary(Tree_A)
  
  s<- fluxes %>% group_by(Tree) %>% 
    do(lmt = lm(CH4_flux~CO2_flux, data=.)) %>% 
    summarise(Tree, adj.r.sq = summary(lmt)$adj.r.squared) 
  s
  
  
  
  # Predicted values of CO2 ----
  
 
  # Predicted values of CH4_bc ----