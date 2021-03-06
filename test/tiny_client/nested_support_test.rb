require 'test_helper'

describe TinyClient::NestedSupport do
  Parent = Class.new(TinyClient::Resource)
  Children = Class.new(TinyClient::Resource)

  let(:resource) { Parent.new }

  it { Parent.must_respond_to :nested }

  it { resource.must_respond_to :nested_index }
  it { resource.must_respond_to :nested_show }
  it { resource.must_respond_to :nested_create }
  it { resource.must_respond_to :nested_update }
  it { resource.must_respond_to :nested_delete }
  it { resource.must_respond_to :nested_all } # pagination

  describe 'ClassMethods#nested_index' do
    it 'properly delegate to Resource#get' do
      Parent.expects(:get).with({}, resource.id, Children.path, Children).returns(Children.new)
      resource.nested_index(Children, {}).is_a?(Children).must_equal true
    end

    it { proc { resource.nested_index(String, {}) }.must_raise ArgumentError }
  end

  describe 'ClassMethods#nested_all' do
    it 'properly delegate to PaginationSupport#get_all' do
      Parent.expects(:get_all).with({}, resource.id, Children.path, Children).returns(Children.new)
      resource.nested_all(Children, {}).is_a?(Children).must_equal true
    end

    it { proc { resource.nested_all(String, {}) }.must_raise ArgumentError }
  end

  describe 'when we add a nested resource' do
    before { Parent.nested Children }

    it { Parent.nested.must_equal [Children] }

    it { resource.must_respond_to :childrens }
    it { resource.must_respond_to :children }
    it { resource.must_respond_to :add_children }
    it { resource.must_respond_to :update_children }
    it { resource.must_respond_to :remove_children }
    it { resource.must_respond_to :childrens_all }
  end

  describe 'when we add a nested resource has more than a word in its name' do
    Role            = Class.new(TinyClient::Resource)
    AppPermission   = Class.new(TinyClient::Resource)
    MyAppPermission = Class.new(TinyClient::Resource)

    let(:resource) { Role.new }

    before { Role.nested AppPermission, MyAppPermission }

    it 'has correct methods' do
      Role.nested.must_equal [AppPermission, MyAppPermission]

      resource.must_respond_to :app_permissions
      resource.must_respond_to :app_permission
      resource.must_respond_to :add_app_permission
      resource.must_respond_to :update_app_permission
      resource.must_respond_to :remove_app_permission
      resource.must_respond_to :app_permissions_all

      resource.must_respond_to :my_app_permissions
      resource.must_respond_to :my_app_permission
      resource.must_respond_to :add_my_app_permission
      resource.must_respond_to :update_my_app_permission
      resource.must_respond_to :remove_my_app_permission
      resource.must_respond_to :my_app_permissions_all
    end
  end
end
