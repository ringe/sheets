module ColumnsHelper
  def get_column(sheet, col)
    script=<<-eojs
$.ajax({
            url: "#{sheet_column_path(sheet, 0)}"+col,
            type: "get",
            dataType: "html"
          })
          .done(function(data) {
            updateForm(data);
          });
    eojs
    script.html_safe
  end
end
