require File.join(File.dirname(__FILE__), %w[spec_helper])

describe "Nested attributes plugin for embedded document" do
  before do
    @klass = Doc('Parent') do
      plugin MongoMapper::Plugins::Associations::NestedAttributes
      key :body, String
    end

    @child_klass = EDoc('Child') do
      before_save :do_bar
      key :value, String

      def do_bar; end
    end

    @brat_klass = EDoc('Brat') do
      before_save :do_bar
      key :value, String

      def do_bar; end
    end

    @klass.many :children, :class => @child_klass
    @klass.has_one :brat, :class => @brat_klass
    # @klass.accepts_nested_attributes_for :children, :brat
    #
    # @parent = @klass.new
  end

  describe "creating new documents" do
    describe "for one-to-one associations" do
      before do
        @klass.accepts_nested_attributes_for :brat
        @parent = @klass.new#.tap{ |p| p.save! }
        @parent.brat_attributes = { :value => "foo" }
      end

      it "should create the brat document" do
        @parent.brat.should_not be_nil
        @parent.brat.value.should == "foo"
      end

      it "should retain it on save" do
        doing {@parent.save!}.should_not raise_error
        @parent.reload
        @parent.brat.should_not be_nil
        @parent.brat.value.should == "foo"
      end

      it "should only call child validations once" do
        pending "This actually works correctly but for some strange reason it creates a brand new object which does not get the mock object"
        @parent.brat.should_receive(:do_bar).once
        doing { @parent.save! }.should_not raise_error
      end
    end

    describe "for collections" do
      before do
        @klass.accepts_nested_attributes_for :children
        @parent = @klass.new.tap{|p| p.save!}
        @parent.children_attributes = [{:value => "foo"}]
      end

      it "should create children document" do
        @parent.children.size.should == 1
        @parent.children[0].value.should == "foo"
      end

      it "should retain it on save" do
        doing {@parent.save!}.should_not raise_error
        @parent.reload
        @parent.children.size.should == 1
        @parent.children[0].value.should == "foo"
      end

      it "should only call child validations once" do
        child = @parent.children[0]
        child.should_receive(:do_bar).once
        doing {@parent.save!}.should_not raise_error
      end
    end
  end

  describe "updating existing documents"

  describe "deleting an existing document" do

    def create_parent_and_brat
      @parent = @klass.new
      @brat = @brat_klass.new(:value => 'foo')
      @parent.brat = @brat
    end

    describe "in a one-to-one association" do
      it 'does nothing unless :allow_destroy is true' do
        @klass.accepts_nested_attributes_for :brat

        create_parent_and_brat

        @parent.brat_attributes = { :id => @brat.id, :_destroy => '1' }
        @parent.save!
        @parent.brat.should_not be_nil
      end

      it 'deletes the document when _destroy is present' do
        @klass.accepts_nested_attributes_for :brat, :allow_destroy => true

        create_parent_and_brat

        @parent.brat_attributes = { :id => @brat.id, :_destroy => '1' }
        @parent.save!
        @parent.brat.should be_nil
      end

      it "does not delete the document until save is called" do
        @klass.accepts_nested_attributes_for :brat, :allow_destroy => true

        create_parent_and_brat
        @parent.brat_attributes = { :id => @brat.id, :_destroy => '1' }
        @parent.brat.should == @brat
        @parent.brat.marked_for_destruction?.should be_true
      end
    end

    describe "in a collection" do
      it 'does nothing unless :allow_destroy is true' do
        @klass.accepts_nested_attributes_for :children

        @parent = @klass.new
        @child = @child_klass.new(:value => 'foo')
        @parent.children << @child

        @parent.children_attributes = [ { :id => @child.id, :_destroy => '1' } ]
        doing do
          @parent.save!
        end.should_not change(@parent.children, :size)
      end

      it 'deletes the document when _destroy is present' do
        @klass.accepts_nested_attributes_for :children, :allow_destroy => true

        @parent = @klass.new
        @child = @child_klass.new(:value => 'foo')
        @parent.children << @child

        @parent.children.size.should eql(1)
        @parent.children_attributes = [ { :id => @child.id, :_destroy => '1' } ]
        @parent.children.size.should eql(1)

        doing do
          @parent.save!
        end.should change(@parent.children, :size)
      end

      it "does not delete the document until save is called" do
        @klass.accepts_nested_attributes_for :children, :allow_destroy => true

        @parent = @klass.new
        @child = @parent.children.build(:value => 'foo')
        @child.save
        @parent.reload

        doing do
          @parent.children_attributes = [ { :id => @child.id, :_destroy => '1' } ]
        end.should_not change(@parent.children, :size)
      end
    end
  end
end
