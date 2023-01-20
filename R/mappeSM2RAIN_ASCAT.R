rm(list=objects())
library("terra")
library("tidyverse")
library("tidyterra")
library("scico")
library("rworldmap")
library("sf")

nomeFile<-"africa_SM2RAIN_ASCAT_0125_2008_2021_v1.5_fixed_monthly.nc"
rast(nomeFile)->mybrick

rworldmap::countriesCoarse->mondo
cleangeo::clgeo_Clean(mondo)->mondo
st_as_sf(mondo)->mondo
mondo %>%
  filter(REGION=="Africa")->africa
st_union(africa)->africa
vect(africa)->maskAfrica

tidyr::expand_grid(yy=2008:2021,mm=1:12) %>%
  mutate(yymmdd=glue::glue("{yy}-{str_pad(mm,pad='0',width=2,side='left')}-15")) %>%
  dplyr::pull(yymmdd)->names(mybrick)

grafico<-function(.mybrick,.year,.mask=NULL){
  
  .mybrick[as.character(.year)]->zz
  if(!is.null(.mask)){ mask(zz,.mask)->zz}
  
  ggplot()+
    geom_spatraster(data = ifel(zz>250,250,zz) )+
    geom_sf(data=africa,fill="transparent",)+
    facet_wrap(~lyr)+
    scale_fill_scico(palette="nuuk",na.value="transparent",direction=-1,guide=guide_colorbar(title="mm/month",barheight =grid::unit(6,"cm")))+
    theme_bw()+
    theme(panel.grid = element_blank())
}


purrr::map(2008:2021,.f=~(grafico(.mybrick=mybrick,.year=.,.mask=maskAfrica)))->listaGrafici
names(listaGrafici)<-paste0("X",2008:2021)


