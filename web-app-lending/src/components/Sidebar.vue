<template lang="pug">
  .bar
    .brand
      img(src="../assets/xfers-logo.png")
    .items
      a.item(
        v-for="item in menuItems"
        :class="{selected: activeIndex === item.pathName}"
        :href="item.href"
        :target="item.target || '_self'"
        @click="handleClick(item, $event)"
      )
        i(:class="item.iconUrl")
        p.text {{item.text}}
    slot(name="bottom")
</template>

<script>
export default {
  data () {
    return {
      menuItems: [
        {
          iconUrl: 'el-icon-menu',
          pathName: 'dashboard',
          text: 'Dashboard'
        }, {
          iconUrl: 'el-icon-document-copy',
          pathName: 'loanslist',
          text: 'Invest'
        }, {
          iconUrl: 'el-icon-map-location',
          pathName: 'heatmap',
          text: 'Heatmap'
        }
      ]
    }
  },
  computed: {
    activeIndex () {
      return this.$route.name
    }
  },
  methods: {
    handleClick (item, $event) {
      item.selected = true
      if (item.click) {
        $event.preventDefault()
        item.click()
      } else {
        this.$router.push({
          name: item.pathName
        })
      }
    }
  }
}
</script>

<style lang="stylus" scoped>
  .bar
    padding-top 35px
    width 100px
    box-shadow 5px -1px 12px 0 rgba(0, 0, 0, 0.2)
    height 100vh
    background-color #2c3e4e
    display flex
    flex-direction column
    .brand
      height 54px
      text-align center
      img
        max-width 90px
    .items
      color white
      padding-top 20px
      flex 1
      .item
        box-sizing border-box
        height 95px
        display flex
        flex-direction column
        justify-content center
        align-items center
        cursor pointer
        padding 0 15px
        text-align center
        color inherit
        transition all 200ms ease-out
        border-right 3px solid transparent
        border-left 3px solid transparent
        &.selected
          opacity 1
          color #131313
          background-color white
        &:hover:not(.selected)
          opacity 1
          background-color hsla(0, 0%, 100%, .05)
          border-left 3px solid $primary
        .text
          margin-bottom 0
        img
          height 30px
          margin-bottom 3px
    .avatar
      display flex
      justify-content center
      align-items center
      height 80px
      padding 0
</style>
