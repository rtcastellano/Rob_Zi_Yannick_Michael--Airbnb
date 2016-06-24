library(plotly)

df <- read.csv('https://raw.githubusercontent.com/plotly/datasets/master/2014_world_gdp_with_codes.csv')


countries = read.csv("../../../data/countries.csv", stringsAsFactors = F)
t = data.frame(abr = c("AU", "CA", "DE", "ES", "FR", "GB", "IT", "NL", "PT", "US"), country.name = c("Australia", "Canada", "Germany", "Spain", "France", "United Kingdom", "Italy", "Netherlands", "Portugal", "United States"))
merged = merge(countries, t, by.x = "country_destination", by.y = "abr", all.x = T)
all_countries = merge(df['COUNTRY'], merged, by.x = 'COUNTRY', by.y = 'country.name', all.x = T)

# light grey boundaries
l <- list(color = toRGB("grey"), width = 0.5)

# specify map projection/options
g <- list(
  showframe = FALSE,
  showcoastlines = FALSE,
  projection = list(type = 'Mercator')
)

plot_ly(all_countries, z = pred, text = hover, locations = COUNTRY,
        type = 'choropleth',
        #color = COUNTRY, 
        marker = list(line = l),
        colors = 'Blues', locationmode = "country names") %>% layout(geo = g)

plot_ly(df, z = GDP..BILLIONS., text = COUNTRY, locations = COUNTRY, type = 'choropleth', locationmode = "country names",
        color = GDP..BILLIONS., colors = 'Blues', marker = list(line = l)) %>% layout(geo = g)

plot_ly(df, z = GDP..BILLIONS., text = COUNTRY, locations = CODE, type = 'choropleth',
        color = GDP..BILLIONS., colors = 'Blues', marker = list(line = l),
        colorbar = list(tickprefix = '$', title = 'GDP Billions US$')) %>%
  layout(title = '2014 Global GDP<br>Source:<a href="https://www.cia.gov/library/publications/the-world-factbook/fields/2195.html">CIA World Factbook</a>',
         geo = g)

