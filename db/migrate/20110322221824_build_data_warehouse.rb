class BuildDataWarehouse < ActiveRecord::Migration
  def self.up
    
    execute "
      CREATE TABLE dim_locations(
        id INTEGER UNSIGNED AUTO_INCREMENT UNIQUE,
        country VARCHAR(100),
        region VARCHAR(100),
        city VARCHAR(100),
        zip VARCHAR(100),
        ip VARCHAR(100),
        latitude FLOAT,
        longitude FLOAT,
        PRIMARY KEY (id)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8
    "
    
    execute "  
      CREATE TABLE dim_periods(
        id INTEGER UNSIGNED AUTO_INCREMENT UNIQUE,
        year INTEGER UNSIGNED,
        month INTEGER UNSIGNED,
        day INTEGER UNSIGNED,
        PRIMARY KEY (id)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8
    "

    execute "
      CREATE TABLE dim_images(
        id INTEGER UNSIGNED AUTO_INCREMENT UNIQUE,
        store VARCHAR(100),
        image VARCHAR(255),
        PRIMARY KEY (id)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8
    "

    execute "
      CREATE TABLE fact_votes(
        id INTEGER UNSIGNED AUTO_INCREMENT UNIQUE,
        dim_location_id INTEGER UNSIGNED,
        dim_period_id INTEGER UNSIGNED,
        dim_image_id INTEGER UNSIGNED,
        votes INTEGER UNSIGNED,
        PRIMARY KEY (id)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8
    "

    execute "ALTER TABLE dim_periods ADD UNIQUE dim_periods_unq (year,month,day)"
    execute "ALTER TABLE dim_locations ADD UNIQUE uniq_ip (ip)"

    execute "ALTER TABLE fact_votes ADD FOREIGN KEY dim_location_id_idxfk (dim_location_id) REFERENCES dim_locations (id)"
    execute "ALTER TABLE fact_votes ADD FOREIGN KEY dim_period_id_idxfk (dim_period_id) REFERENCES dim_periods (id)"
    execute "ALTER TABLE fact_votes ADD FOREIGN KEY dim_image_id_idxfk (dim_image_id) REFERENCES dim_images (id)"
    
  end

  def self.down
    execute "DROP TABLE fact_votes"
    execute "DROP TABLE dim_locations"
    execute "DROP TABLE dim_periods"
    execute "DROP TABLE dim_images"
  end
end
