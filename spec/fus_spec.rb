require 'spec_helper'

describe Fus::Finder do
  describe "swift_classes" do
    it "returns all of the classes in all the swift paths" do
      finder = Fus::Finder.new("./fixtures")
      expect(finder.swift_classes).to include("Foo", "ClassVar", "SuperFoo", "NoSpaceSuperFoo", "UnusedClass", "ObjCH", "ObjCM")
      expect(finder.swift_classes.count).to eq(7)
    end
  end
  
  describe "unused_classes" do
    it "returns classes that are never used" do
      finder = Fus::Finder.new("./fixtures")
      expect(finder.unused_classes).to include("UnusedClass")
      expect(finder.unused_classes.count).to eq(1)
    end
  end
  
  describe "+swift_class_is_used_in_text" do
    it "returns true if the class is initialized in the text" do
      was_used = Fus::Finder.swift_class_is_used_in_text("Foo", "Foo()")
      expect(was_used).to be_truthy
    end
    
    it "returns true if the class is used as a superclass with a space" do
      was_used = Fus::Finder.swift_class_is_used_in_text("Foo", "class Bar : Foo")
      expect(was_used).to be_truthy
    end
    
    it "returns true if the class is used as a superclass without a space" do
      was_used = Fus::Finder.swift_class_is_used_in_text("Foo", "class Bar: Foo")
      expect(was_used).to be_truthy
    end
    
    it "returns true if a class var is used" do
      was_used = Fus::Finder.swift_class_is_used_in_text("Foo", "Foo.magic")
      expect(was_used).to be_truthy
    end
    
    it "returns true if a class func is used" do
      was_used = Fus::Finder.swift_class_is_used_in_text("Foo", "Foo.magic()")
      expect(was_used).to be_truthy
    end
    
    it "returns false if the class is never used" do
      was_used = Fus::Finder.swift_class_is_used_in_text("Foo", "Bar.magic()")
      expect(was_used).to be_falsy
    end
  end

  describe "+obj_c_class_is_used_in_text" do
    it "returns true if the classname appears" do
      was_used = Fus::Finder.obj_c_class_is_used_in_text("Foo", "Foo")
      expect(was_used).to be_truthy
    end
    
    it "returns false if the classname does not appear" do
      was_used = Fus::Finder.obj_c_class_is_used_in_text("Foo", "Bar")
      expect(was_used).to be_falsy
    end
  end
  
  describe "+path_matches_classname" do
    it "returns true if the path ends in classname.swift" do
      matches = Fus::Finder.path_matches_classname("Foo", "x/y/z/Foo.swift")
      expect(matches).to be_truthy
    end
    
    it "returns false if the path doesn't include the pathname" do
      matches = Fus::Finder.path_matches_classname("Foo", "x/y/z/Bar.swift")
      expect(matches).to be_falsy
    end
    
    it "returns false if the path includes the pathname and extra words" do
      matches = Fus::Finder.path_matches_classname("Foo", "x/y/z/FooBar.swift")
      expect(matches).to be_falsy  
    end
  end
end