class <%= controller.class_name %>Controller < ApplicationController
  before_action :set_<%= singular_table_name %>, only: [:show, :edit, :update, :destroy]

  def index
    @<%= plural_table_name %> = index_object <%= class_name %>, params
  end

  def show
  end

  def new
    @<%= singular_table_name %> = <%= class_name %>.new
  end

  def edit
  end

  def create
    @<%= singular_table_name %> = <%= class_name %>.new(<%= singular_table_name %>_params)
    save_object @<%= singular_table_name %>
  end

  def update
    @<%= singular_table_name %>.assign_attributes(<%= singular_table_name %>_params)
    save_object @<%= singular_table_name %>
  end

  def destroy
    destroy_object @<%= singular_table_name %>, <%= plural_table_name %>_url
  end

  private
    def set_<%= singular_table_name %>
      @<%= singular_table_name %> = <%= class_name %>.find(params[:id])
    end

    def <%= singular_table_name %>_params
      <%- if attributes_names.empty? -%>
      params[:<%= singular_table_name %>]
      <%- else -%>
      params.require(:<%= singular_table_name %>).permit(<%= attributes_names.map { |name| :<%= name %> }.join(', ') %>)
      <%- end -%>
    end
end
