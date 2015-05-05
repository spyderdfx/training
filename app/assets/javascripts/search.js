var ajax_update = function(){
  $.get("/search/status",function(data){
    $("#session_status").html(
      "<p>Время запуска: " + toDateTime(data.time) + "</p>" +
      "<p>Статус: " + data.status + "</p>" +
      "<p>Сообщение: " + data.message + "</p>");
  });
}

function toDateTime(seconds)
{
  var t = new Date(1970,0,1);
  t.setSeconds(seconds);
  return t;
}

$(function()
{
  setInterval(ajax_update, 1000);
});
