---
title: Vue多语言-vue-i18n
date: 2022/02/16
tags: 多语言,i18n
categories: Vue
description: 有些项⽬我们需要⽀持多种语⾔切换，满⾜国际化需求。 vue-i18n是⼀个vue插件，主要作⽤就是让项⽬⽀持国际化多语⾔，使⽤⽅便快捷，能很轻松的将我们的项⽬国际化。本⽂主要介绍使⽤vue-i18n实现切换中英⽂效果。
keywords: 多语言,i18n
cover: /img/md/vue.jpg
---

# 安装vue-i18n
```bach
npm install vue-i18n -S
yarn add vue-i18n
```

# 创建多语言文件夹lang，并且创建index.js、zh.js

index.js内容如下：
```javascript
import Vue from 'vue'
import VueI18n from 'vue-i18n'
import Cookies from 'js-cookie'
import elementZhLocale from 'element-ui/lib/locale/lang/zh-CN'// element-ui lang
import zhLocale from './zh'

Vue.use(VueI18n)

export const DEFAULT_LOCALE_MSG = {
  zh: {
    ...zhLocale,
    ...elementZhLocale
  }
}

const messages = Object.assign({}, DEFAULT_LOCALE_MSG)

export function getLanguage() {
  const chooseLanguage = Cookies.get('language')
  if (chooseLanguage) return chooseLanguage

  // if has not choose language
  const language = (navigator.language || navigator.browserLanguage).toLowerCase()
  const locales = Object.keys(messages)
  for (const locale of locales) {
    if (language.indexOf(locale) > -1) {
      return locale
    }
  }
  return 'zh'
}

const i18n = new VueI18n({
  locale: getLanguage(),
  messages
})

export default i18n

```

zh.js内容如下：
```javascript
export default {
  loading: {
    msg: '正在加载数据，请稍候...'
  }
}
```

# 在main.js中引入vue-i18n

```javascript
import i18n from '@/lang'

Vue.use(ElementUI, {
  i18n: (key, value) => i18n.t(key, value),
  size:'mini'
})
new Vue({
  i18n
})
```

# vuex管理多语言问题

## 在store文件夹下创建文件夹modules，并且创建index.js

```javascript
import Vue from 'vue'
import Vuex from 'vuex'
import app from './modules/app'

Vue.use(Vuex)

/**
 * 添加 modules 自动装配
 */
const modules = {}
const require_module = require.context('./modules', false, /.js$/)
require_module.keys().forEach((file_name) => {
  modules[file_name.slice(2, -3)] = require_module(file_name).default
})

const store = new Vuex.Store({
  modules: {
    app
  }
})

export default store

```

## 在modules文件夹下创建app.js
```javascript
import Cookies from 'js-cookie'
import {getLanguage} from '@/lang'

const state = {
  language: getLanguage()
}

const mutations = {
  SET_LANGUAGE: (state, language) => {
    state.language = language
    Cookies.set('language', language)
  }
}

const actions = {
  setLanguage({commit}, language) {
    commit('SET_LANGUAGE', language)
  }
}

const getters = {
  language: state => state.language
}

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
}

```

# 语言切换
```javascript
await this.$store.dispatch('app/setLanguage', 'zh')
```

# 动态多语言文件(服务器加载)

## 在App.vue
```javascript
import {getMessageInfo} from '@/i18n'

async created() {
  const lang = getLanguage()
  console.log('当前系统语言：', lang)
  const {defaultLangObj, msgObj} = await this.loadSettingByLang(lang)
  this.$i18n.setLocaleMessage(lang, {
    ...defaultLangObj, ...msgObj
  })
},
methods: {
  async loadSettingByLang(lang = 'zh') {
    const msgObjStr = localStorage.getItem('local-data-mag')
    let msgObj
    if (msgObjStr) {
      msgObj = JSON.parse(msgObjStr)
    } else {
      // console.log('从后台加载消息语言文件', msgObjRes)
      const msgObjRes = await getMessageInfo(lang) // 请求后台多语言API
      msgObj = this.generateMsgObj(msgObjRes)
    }
    const defaultLangObj = DEFAULT_LOCALE_MSG[lang]
    // console.log('原语言文件对象：', defaultLangObj)
    return {defaultLangObj, msgObj}
  },
  generateMsgObj(messageArray = {}) {
    localStorage.setItem('local-data-mag', JSON.stringify(messageArray))
    return allMsgInfo
  },
  clearLanguageCache() {
    localStorage.removeItem('local-data-mag')
  }
}
```

# 使用方式
## 调用方式
```javascript
{{ $t('loading.msg') }}
this.$t('loading.msg')
```
## 处理动态变量参数方法
```javascript
/**
 * 替换双语消息提示中的变量
 * @param{String} data 双语字符串
 * @param{Array} args
 * @returns{string}
 */
export const convertVariateFromTips = (data = '', args = []) => {
  const regExp = /[#$]\d/gi
  const arr = data.match(regExp)
  const newObj = {}
  arr.forEach((item, index) => {
    newObj[item] = args[parseInt(item.replace('$','')) - 1]
  })
  return data.replace(regExp, (result) => {
    return newObj[result]
  })
}

// 使用方式
console.log(convertVariateFromTips('$2在$1之前输入文字', ['a的位置','请']))
//请在a的位置之前输入文字
```
