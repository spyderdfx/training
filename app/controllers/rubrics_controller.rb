class RubricsController < ApplicationController
  def index
  	connection = ActiveRecord::Base.establish_connection(
			adapter:  'postgresql',
			host:     'localhost',
			port:     '5432',
			username: 'postgres',
			password: 'postgres',
			database: 'training'
		)

		@result_sql_query = ActiveRecord::Base.connection.execute("SELECT
																											rubrics.id,
																											rubrics.cached_level,
																											rubrics.title,
																											count(products.name) count_of_products
																										FROM
																											products
																										INNER JOIN
																											rubrics
																										ON
																											rubrics.id = products.rubric_id
																										WHERE
																											lower(products.name) LIKE '% молоко %'
																										GROUP BY
																											rubrics.id,
																											rubrics.cached_level,
																											rubrics.title
																										ORDER BY
																											count_of_products DESC")

		@result_ar_query = Rubric.joins(:products).where("lower(products.name) LIKE ?", "% молоко %")
													.group("rubrics.id", "rubrics.cached_level", "rubrics.title")
													.order("count_of_products desc")
													.pluck("rubrics.id", "rubrics.cached_level", "rubrics.title", "count(products.name) as count_of_products")										
  end
end
