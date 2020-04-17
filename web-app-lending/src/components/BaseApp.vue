<template lang="pug">
  .lending-app
    sidebar
    router-view.main-content(v-if="loaded")
</template>

<script>
import Sidebar from './Sidebar'
import {
  Card as ElCard
} from 'element-ui'
import userIdentification from './mixins/userIdentification'

export default {
  data () {
    return {
      loaded: false
    }
  },
  methods: {
    async checkAuth () {
      const token = await this.isLoggedIn()
      if (!token) {
        this.$router.push({
          name: 'login'
        })
      }
      this.loaded = true
    }
  },
  created () {
    this.checkAuth()
  },
  mixins: [ userIdentification ],
  components: {
    Sidebar,
    ElCard
  }
}
</script>

<style lang="stylus" scoped>
  .lending-app
    background rgb(250,250,250)
    display flex
    flex-direction row

  .main-content
    border 1px solid rgba(0,0,0,0.1)
    overflow scroll
    width 100%
    margin 15px
    background white
    max-height 100vh
    box-shadow 0 1px 3px 0 rgba(0,0,0,.2), 0 1px 1px 0 rgba(0,0,0,.14), 0 2px 1px -1px rgba(0,0,0,.12)
</style>
