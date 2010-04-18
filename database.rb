DataMapper.setup(:default, ENV['DATABASE_URL'] || {
  :adapter  => 'mysql',
  :host     => 'localhost',
  :username => 'root' ,
  :password => '',
  :database => 'themarymanual'})