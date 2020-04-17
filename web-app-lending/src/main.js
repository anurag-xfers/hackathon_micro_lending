import Vue from 'vue'
import App from './App.vue'
import store from './store'
import router from './router'
import { Loading } from 'element-ui'
import 'element-ui/lib/theme-chalk/index.css'

Vue.config.productionTip = false
Vue.use(Loading.directive)

new Vue({
  store,
  router,
  render: h => h(App)
}).$mount('#app')
