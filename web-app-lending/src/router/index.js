import Vue from 'vue'
import Router from 'vue-router'

import BaseApp from '../components/BaseApp'
import Login from '../components/Login'

import Dashboard from '../components/Dashboard'
import LoansList from '../components/Loans/LoansList'

Vue.use(Router)

const authRoutes = [
  {
    name: 'dashboard',
    path: '/dashboard',
    component: Dashboard
  }, {
    name: 'loanslist',
    path: '/invest',
    component: LoansList
  }, {
    path: '*',
    redirect: '/dashboard'
  }
]

const router = new Router({
  mode: 'history',
  routes: [
    {
      path: '/login',
      name: 'login',
      component: Login
    },
    {
      name: 'app',
      path: '/',
      component: BaseApp,
      children: authRoutes
    },
    {
      path: '*',
      redirect: '/'
    }
  ]
})

export default router
