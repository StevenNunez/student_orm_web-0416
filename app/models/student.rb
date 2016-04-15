class Student
  @@db = SQLite3::Database.new('db/students.db')
  @@db.results_as_hash = true

  attr_accessor :id, :name, :super_power
  def self.new_from_row(row)
    instance = self.new
    instance.id = row["id"]
    instance.name = row["name"]
    instance.super_power = row["super_power"]
    instance
  end

  def self.all
    query = <<-SQL
      SELECT * FROM students
    SQL
    rows = @@db.execute(query)
    rows.map {|row| self.new_from_row(row)}
  end

  def self.find(id)
    query = <<-SQL
      SELECT *
      FROM students
      WHERE id=?
      LIMIT 1
    SQL
    # result = @@db.execute(query).first
    # self.new_from_row(result) if result
    @@db.execute(query, id).map {|row| self.new_from_row(row)}.first
  end

  def self.find_by_name(name)
    query = <<-SQL
      SELECT *
      FROM students
      WHERE name=?
      LIMIT 1
    SQL
    @@db.execute(query, name).map {|row| self.new_from_row(row)}.first
  end

  def save
    # if persisted?
    #   update
    # else
    #   insert
    # end
    persisted? ? update : insert
  end

  def persisted?
    !!self.id
  end

  def delete
    query = <<-SQL
      DELETE FROM students
      WHERE id=?
    SQL

    @@db.execute(query, self.id)
  end

  private
  def insert
    query = <<-SQL
      INSERT INTO students (name, super_power)
      VALUES(?,?)
    SQL

    @@db.execute(query, self.name, self.super_power)
  end

  def update
    query = <<-SQL
       UPDATE students
       SET name=?, super_power=?
       WHERE id=?
    SQL

    @@db.execute(query, self.name, self.super_power, self.id)
  end
end
