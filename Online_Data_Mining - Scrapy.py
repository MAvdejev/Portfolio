import scrapy

class Movie (scrapy.Item):
    title = scrapy.Field()
    director = scrapy.Field()
    genre = scrapy.Field()

class MetacriticSpider(scrapy.Spider):
    name = "metacritic"
    allowed_domains = ["www.metacritic.com"]
    start_urls = ["https://www.metacritic.com/browse/movie/"]


    def parse(self, response):
        # Extracting links to individual movie pages
        movie_links = response.css('.clamp-details a.title::attr(href)').extract()

        for movie_link in movie_links:
            yield scrapy.Request(url=movie_link, callback=self.parse_movie)

        # Follow pagination link
        next_page = response.css('.pages .next_page::attr(href)').extract_first()
        if next_page:
            yield scrapy.Request(url=next_page, callback=self.parse)

    def parse_movie(self, response):
        # Extracting data from individual movie pages
        title = response.css('.c-finderProductCard_titleHeading span:last-child::text').extract_first().strip()
        release_date = response.css('.c-finderProductCard_meta span:nth-child(1)::text').extract_first().strip()
        rating = response.css('.c-finderProductCard_meta span:nth-child(3)::text').extract_first().strip()
        metascore = response.css('.c-finderProductCard_score span::text').extract_first().strip()

        description = response.css('.c-finderProductCard_description span::text').extract_first().strip()

        yield {
            'title': title,
            'release_date': release_date,
            'rating': rating,
            'metascore': metascore,
            'description': description,
        }

