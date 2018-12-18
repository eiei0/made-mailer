import Vue from "vue";
import App from "../components/nav_bar/App";
import Vuetify from 'vuetify'

Vue.use(Vuetify)

document.addEventListener("DOMContentLoaded", () => {
  const app = new Vue({
    el: "#nav-bar",
    render: h => h(App)
  });
});
