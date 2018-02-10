$('#calendar').fullCalendar({
  header: {
    left: 'prev,next today',
    center: 'title',
    right: 'month,agendaWeek,agendaDay'
  },
  allDaySlot: false,
  agendaEventMinHeight: 800,
  defaultView: 'agendaWeek',
  agendaEventMinHeight: 25,
  events: '/emails.json'
});
