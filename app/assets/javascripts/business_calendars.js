$('#calendar').fullCalendar({
  header: {
    left: 'prev,next today',
    center: 'title',
    right: 'month,agendaWeek,agendaDay'
  },
  eventRender: function(event, element) {
    element.find('.fc-title').append("<br/>" + event.description);
  },
  allDaySlot: false,
  displayEventTime: false,
  agendaEventMinHeight: 800,
  agendaEventMinHeight: 25,
  events: '/emails.json'
});
