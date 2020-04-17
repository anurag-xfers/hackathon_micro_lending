export const searchEntity = ({ search = '', limit = 20, sort = {} }) => ({
  query: '',
  params: {
    search,
    limit,
    order: sort.order,
    prop: sort.prop,
    sort,
    skip: 0
  },
  next: function () {
    this.params.skip += limit
    return this
  },
  previous: function () {
    this.params.skip = Math.min(this.params.skip - limit, 0)
    return this
  }
})
