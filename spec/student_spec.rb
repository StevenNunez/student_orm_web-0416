RSpec.describe Student do
  describe "creating from row set" do
    it "converts it properly" do
      row_set = {
        "id"=>1,
       "name"=>"Jacob",
       "super_power"=>"Ninja code writing",
       0=>1,
       1=>"Jacob",
       2=>"Ninja code writing"
     }

     student = Student.new_from_row(row_set)
     expect(student.id).to eq(1)
     expect(student.name).to eq("Jacob")
     expect(student.super_power).to eq("Ninja code writing")
    end
  end

  context "Finders" do
    # Static finder methods to wrap commonly used
    # SQL queries and return Active Record objects
    it "returns all students in the database" do
      students = Student.all
      student = students.first
      expect(student).to be_a(Student)
      expect(student.name).to eq("Jacob")
    end

    it "finds a single record by id" do
      student = Student.find(7)
      expect(student.id).to eq(7)
      expect(student.name).to eq("Gabriel")
      expect(student.super_power).to eq("Tears of Wine")
    end

    it "returns nil if student isn't found" do
      student = Student.find(9001)
      expect(student).to be_nil
    end

    it "isn't susceptale to sql injection" do
      student = Student.find("7 OR 1=1;--")
      expect(student).to be_nil
    end

    it "Finds a student by name" do
      student = Student.find_by_name("Gabriel")
      expect(student.id).to eq(7)
      expect(student.name).to eq("Gabriel")
    end
  end

  context "Persisting" do
    # Update the database and insert into it the
    # data in the Active Record
    before do
      student = Student.find_by_name("Bobby")
      student.delete if student
      generalissimo = Student.find_by_name("Generalissimo Felipe de la Costa")
      generalissimo.delete if generalissimo
    end

    it "saves new instances to the database" do
      bob = Student.new
      bob.name = "Bobby"
      bob.super_power = "Bear Fighting"
      bob.save

      found_bob = Student.find_by_name("Bobby")
      expect(found_bob.name).to eq("Bobby")
      expect(found_bob.super_power).to eq("Bear Fighting")
    end

    it "Updates a user" do
      bob = Student.new
      bob.name = "Bobby"
      bob.super_power = "Bear Fighting"
      bob.save

      found_bob = Student.find_by_name("Bobby")
      found_bob.name = "Generalissimo Felipe de la Costa"
      found_bob.save

      generalissimo = Student.find_by_name("Generalissimo Felipe de la Costa")
      expect(generalissimo.super_power).to eq("Bear Fighting")
      expect(Student.find_by_name('Bobby')).to be_nil
      expect(found_bob.id).to eq(generalissimo.id)
    end
  end
end
