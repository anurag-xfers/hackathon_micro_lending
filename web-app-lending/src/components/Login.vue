<template lang="pug">
  .login-form
    el-form(:ref="formName", :model="form", :rules="rules")
      el-form-item(label="Username", prop="username")
        el-input(v-model="form.username")
      el-form-item(label="Password", prop="password")
        el-input(v-model="form.password", type="password")
      el-form-item
        el-button(
          type="primary"
          @click="submitForm"
        ) Submit
</template>

<script>
import {
  Form as ElForm,
  FormItem as ElFormItem,
  Input as ElInput,
  Button as ElButton
} from 'element-ui'

import { setItem } from '../helpers/storage'
import userIdentification from './mixins/userIdentification'
import { AUTH_KEY } from '../constants'

export default {
  data () {
    return {
      formName: 'loginForm',
      form: {
        username: '',
        password: ''
      },
      rules: {
        password: [
          { required: true, message: 'Please enter the password', trigger: 'blur' }
        ],
        username: [
          { required: true, message: 'Please enter the username', trigger: 'blur' }
        ]
      }
    }
  },
  methods: {
    submitForm () {
      this.$refs[this.formName].validate(async valid => {
        if (!valid) return
        const { username, password } = this.form
        const loggedIn = await this.$neo4j.init(username, password)
        if (loggedIn) this.finishLogin(loggedIn)
      })
    },
    async finishLogin (creds) {
      await setItem(AUTH_KEY, creds)
      this.$router.push({name: 'dashboard'})
    },
    async autoLogin () {
      const token = await this.isLoggedIn()
      if (token) this.finishLogin(token)
    }
  },
  mounted () {
    this.autoLogin()
  },
  mixins: [ userIdentification ],
  components: {
    ElForm,
    ElFormItem,
    ElInput,
    ElButton
  }
}
</script>

<style scoped>
  .login-form {
    margin: auto;
    max-width: 500px;
  }

</style>
