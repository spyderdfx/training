require 'csv'

class RubricsController < ApplicationController
	def connection_to_db
		connection = ActiveRecord::Base.establish_connection(
			adapter:  'postgresql',
			host:     'localhost',
			port:     '5432',
			username: 'postgres',
			password: 'postgres',
			database: 'training'
		)
	end

	def query_to_db(connection)
		ActiveRecord::Base.connection.execute("SELECT
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
	end

	def query_to_db_activerecord_way
		Rubric.joins(:products).where("lower(products.name) LIKE ?", "% молоко %")
													.group("rubrics.id", "rubrics.cached_level", "rubrics.title")
													.order("count_of_products desc")
													.pluck("rubrics.id", "rubrics.cached_level", "rubrics.title", "count(products.name) as count_of_products")
	end

  def index
		@result_sql_query = query_to_db(connection_to_db)

		@result_ar_query = query_to_db_activerecord_way
  end

  def export
  	@result_ar_query = query_to_db_activerecord_way

  	CSV.open("public/rubrics.csv", 'w') do |csv_object|
  		csv_object << "ID рубрики,Уровень рубрики,Заголовок рубрики,Количество товаров со словом 'Молоко'".parse_csv
  		@result_ar_query.to_a.each do |row|
    		csv_object << row
  		end
		end

		send_file "public/rubrics.csv", :type => 'text/csv; charset=utf-8; header=present', :disposition => "attachment; filename=rubrics.csv"
  end
end
