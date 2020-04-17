<template lang="pug">
  .loan-list
    el-table(
      :loading="loading"
      :data="filteredData"
      @sort-change="updateSort"
    )
      template(slot="empty")
        span(v-if="!loading") {{emptyMessage}}
        i(class="el-icon-loading", v-else, style="font-size: 24px")
      el-table-column(type="expand")
        template(slot-scope="scope")
      el-table-column(
        v-for="(col, index) in columns",
        :key="col.name",
        :prop="col.name",
        :label="col.label"
      )
        template(slot-scope="scope")
          span {{scope.row[col.name]}}
      el-table-column
        template(
          slot="header",
          slot-scope="scope"
        )
          el-input(
            v-model="search",
            size="mini",
            @keyup.enter.native="searchFunction"
            placeholder="Type to search"
          )
        template(slot-scope="scope")
          span {{scope.row.countryCodes}}
    .pagination
      el-button(
        size="mini"
        :disabled="page === 0"
        @click="changePage(page - 1)"
        icon="el-icon-arrow-left"
      )
      span(style="padding: 0 10px") {{page + 1}}
      el-button(
        size="mini"
        :disabled="!hasMore"
        @click="changePage(page + 1)"
        icon="el-icon-arrow-right"
      )
</template>

<script>
import {
  Table as ElTable,
  TableColumn as ElTableColumn,
  Input as ElInput,
  Button as ElButton
} from 'element-ui'
import userIdentification from '../mixins/userIdentification'
import { searchEntity } from '../../services/queries'
import { equals } from 'ramda'

// const LIMIT = 20
const SORT_MAPPING = {
  'descending': 'DESC',
  'ascending': 'ASC'
}

export default {
  data () {
    return {
      loading: false,
      search: '',
      emptyMessage: 'No entities found',
      page: 0,
      hasMore: false,
      filteredData: []
    }
  },
  methods: {
    updateSort (sortOrder) {
      const sort = {
        order: SORT_MAPPING[sortOrder.order],
        prop: sortOrder.prop
      }
      this.searchFunction(sort)
    },
    parseData (data) {
      return data.reduce((result, currentRecord) => {
        const res = currentRecord.keys.reduce((obj, rec) => {
          obj[rec] = currentRecord.get(rec)
          return obj
        }, {})
        result.push(res)
        return result
      }, [])
    },
    changePage (newPage) {
      if (newPage < this.page) {
        this.currentSearch.previous()
      } else if (newPage > this.page) {
        this.currentSearch.next()
      } else {
        return
      }
      this.page = newPage
      this.fetchData()
    },
    async fetchData () {
      this.loading = true
      // this.filteredData = []
      // const resp = await this.executeQuery(this.currentSearch)
      // this.filteredData = this.parseData(resp.records)
      // if (this.filteredData.length < LIMIT) {
      //   this.hasMore = false
      // }
      this.loading = false
    },
    async searchFunction (sort) {
      if (this.currentSearch) {
        if (this.search === this.currentSearch.search || equals(this.currentSearch.params.sort, sort)) {
          return
        }
      }
      this.page = 0
      this.hasMore = true
      this.currentSearch = searchEntity({search: this.search, sort: sort})
      this.fetchData()
    }
  },
  created () {
    this.columns = [
      {
        name: 'name',
        label: 'User'
      }, {
        name: 'roi',
        label: 'Interest rate (% p.a)'
      }, {
        name: 'period',
        label: 'Period'
      }, {
        name: 'status',
        label: 'Status'
      }
    ]
    this.currentSearch = null
  },
  mounted () {
    this.searchFunction()
  },
  mixins: [ userIdentification ],
  components: {
    ElTable,
    ElTableColumn,
    ElInput,
    ElButton
  }
}
</script>

<style lang="stylus" scoped>
  .pagination
    background white
    padding 20px
</style>
