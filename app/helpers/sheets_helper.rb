module SheetsHelper
  def send_change(sheet, data)
    script=<<-eojs
$.ajax({
            url: "#{sheet_path(sheet)}",
            type: "put",
            dataType: "json",
            data: { #{data} }
          });
    eojs
    script.html_safe
  end
end
