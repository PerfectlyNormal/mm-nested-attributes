require File.join(File.dirname(__FILE__), %w[spec_helper])

describe "Nested attributes plugin" do
  before do
    @klass = Doc('Parent') do
      plugin MongoMapper::Plugins::Associations::NestedAttributes
      key :body, String
    end

    @child_klass = Doc('Child') do
      key :value, String
    end

    @solo_klass = Doc('Solo') do
      key :value, String
    end

    @klass.many :children, :class => @child_klass
    @klass.one :solo, :class => @solo_klass
    @klass.accepts_nested_attributes_for :children, :solo

    @parent = @klass.new
  end

  it "responds to #<plural_association>_attributes=" do
    @parent.should respond_to(:children_attributes=)
  end

  it "responds to #<singular_association>_attributes=" do
    @parent.should respond_to(:solo_attributes=)
  end

  it "raises an error for undefined associations" do
    doing { @klass.accepts_nested_attributes_for :foo }.should(
      raise_error(ArgumentError, "No association found for name 'foo'. Has it been defined yet?"))
  end

  it 'rejects the document if _destroy flag is present' do
    @parent = @klass.new(:children_attributes => [ { :value => 'ok' }, { :value => 'not ok', :_destroy => '1' } ])
    @parent.children.size.should == 1
    @parent.children[0].value.should == 'ok'
  end
end