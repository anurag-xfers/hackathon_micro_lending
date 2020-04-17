import { AUTH_KEY } from '../../constants'
import { getItem, clearItem } from '../../helpers/storage'

export default {
  methods: {
    async attemptLogin() {
      const token = await getItem(AUTH_KEY)
      if (token) {
        return token
      }
      return false
    },
    async isLoggedIn() {
      return true
    },
    async forceLogout() {
      await clearItem(AUTH_KEY)
      this.$router.push({ name: 'login' })
    }
  }
}
