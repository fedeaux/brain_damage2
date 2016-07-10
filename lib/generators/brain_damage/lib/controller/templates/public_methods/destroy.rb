def destroy
  @<%= orm_instance.destroy %>

  respond_to do |format|
    format.json {
      render nothing: true, status: 200
    }

    format.html {
      redirect_to <%= index_helper %>_url, notice: t('common.destroyed').capitalize
    }
  end

end
