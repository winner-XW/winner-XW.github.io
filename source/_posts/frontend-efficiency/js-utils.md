---
title: JavaScript常用的工具函数汇总
date: 2024/08/13
tags: [工具类,JavaScript]
categories: 前端-开发效率
description: 随着开发经验的积累，很多人会有自己的常用站点，一些网址收藏，自己造的轮子或者别人的轮子，工具函数库等等。
cover: /img/md/js.jpg
---

# 格式化时间戳
```javascript
export function formatDateTimeStamp(date, fmt) {
    // 格式化时间戳 : formatDateTimeStamp(new Date(time),'yyyy-MM-dd hh:mm:ss')
    if (/(y+)/.test(fmt)) {
        fmt = fmt.replace(RegExp.$1, (date.getFullYear() + '').substr(4 - RegExp.$1.length))
    }
    let o = {
        'M+': date.getMonth() + 1,
        'd+': date.getDate(),
        'h+': date.getHours(),
        'm+': date.getMinutes(),
        's+': date.getSeconds()
    }
    for (let k in o) {
        if (new RegExp(`(${k})`).test(fmt)) {
            let str = o[k] + ''
            fmt = fmt.replace(
                RegExp.$1, (RegExp.$1.length === 1) ?
                str :
                padLeftZero(str))
        }
    }
    return fmt
}

function padLeftZero(str) {
    return ('00' + str).substr(str.length);
}

export function parseTime(time, cFormat) {
    if (arguments.length === 0) {
        return null
    }
    const format = cFormat || '{y}-{m}-{d} {h}:{i}:{s}'
    let date
    if (typeof time === 'object') {
        date = time
    } else {
        if ((typeof time === 'string') && (/^[0-9]+$/.test(time))) {
            time = parseInt(time)
        }
        if ((typeof time === 'number') && (time.toString().length === 10)) {
            time = time * 1000
        }
        date = new Date(time)
    }
    const formatObj = {
        y: date.getFullYear(),
        m: date.getMonth() + 1,
        d: date.getDate(),
        h: date.getHours(),
        i: date.getMinutes(),
        s: date.getSeconds(),
        a: date.getDay()
    }
    const time_str = format.replace(/{([ymdhisa])+}/g, (result, key) => {
        const value = formatObj[key]
        // Note: getDay() returns 0 on Sunday
        if (key === 'a') {
            return ['日', '一', '二', '三', '四', '五', '六'][value]
        }
        return value.toString().padStart(2, '0')
    })
    return time_str
}

// for example
// formatDateTimeStamp(new Date(1632744272 * 1000),'yyyy-MM-dd hh:mm:ss') 
// parseTime(1632744272) 
// 输出 ---> 2021-09-27 20:04:32 
```

# url参数转为对象
```javascript
/**
 * @param {string} url
 * @returns {Object}
 */
export function getQueryObject(url) {
    url = url == null ? window.location.href : url
    const search = url.substring(url.lastIndexOf('?') + 1)
    const obj = {}
    const reg = /([^?&=]+)=([^?&=]*)/g
    search.replace(reg, (rs, $1, $2) => {
        const name = decodeURIComponent($1)
        let val = decodeURIComponent($2)
        val = String(val)
        obj[name] = val
        return rs
    })
    return obj
}
// or
/**
 * @param {string} url
 * @returns {Object}
 */
export function param2Obj(url) {
    const search = url.split('?')[1]
    if (!search) {
        return {}
    }
    return JSON.parse(
        '{"' +
        decodeURIComponent(search)
        .replace(/"/g, '\\"')
        .replace(/&/g, '","')
        .replace(/=/g, '":"')
        .replace(/\+/g, ' ') +
        '"}'
    )
}
// for example 
// getQueryObject('http://xxxxxx/index?id=123')
// param2Obj('http://xxxxxx/index?id=123')
// 输出 ---> {id: "123"}
```

# 对象序列化【对象转url参数】
```javascript
/**
 * @param {Array} actual
 * @returns {Array}
 */
function cleanArray(actual) {
    const newArray = []
    for (let i = 0; i < actual.length; i++) {
        if (actual[i]) {
            newArray.push(actual[i])
        }
    }
    return newArray
}
/**
 * @param {Object} obj
 * @returns {Array}
 */
export function param(obj) {
    if (!obj) return ''
    return cleanArray(
        Object.keys(obj).map(key => {
            if (obj[key] === undefined) return ''
            return encodeURIComponent(key) + '=' + encodeURIComponent(obj[key])
        })
    ).join('&')
}

// or

export function stringfyQueryStr(obj) { 
    if (!obj) return '';
    let pairs = [];
    for (let key in obj) {
        let value = obj[key];
        if (value instanceof Array) {
            for (let i = 0; i < value.length; ++i) {
                pairs.push(encodeURIComponent(key + '[' + i + ']') + '=' + encodeURIComponent(value[i]));
            }
            continue;
        }
        pairs.push(encodeURIComponent(key) + '=' + encodeURIComponent(obj[key]));
    }
    return pairs.join('&');
}

// for example

param({name:'1111',sex:'wwww'})
stringfyQueryStr({name:'1111',sex:'wwww'})
// ---> 输出 name=1111&sex=wwww
```

# 本地存储
```javascript
export const store = { // 本地存储
    set: function(name, value, day) { // 设置
        let d = new Date()
        let time = 0
        day = (typeof(day) === 'undefined' || !day) ? 1 : day // 时间,默认存储1天
        time = d.setHours(d.getHours() + (24 * day)) // 毫秒
        localStorage.setItem(name, JSON.stringify({
            data: value,
            time: time
        })) 
    },
    get: function(name) { // 获取
        let data = localStorage.getItem(name)
        if (!data) {
            return null
        }
        let obj = JSON.parse(data)
        if (new Date().getTime() > obj.time) { // 过期
            localStorage.removeItem(name)
            return null
        } else {
            return obj.data
        }
    },
    clear: function(name) { // 清空
        if (name) { // 删除键为name的缓存
            localStorage.removeItem(name)
        } else { // 清空全部
            localStorage.clear()
        }
    }
}
```

# cookie操作
```javascript
export const cookie = { // cookie操作【set，get，del】
    set: function(name, value, day) {
        let oDate = new Date()
        oDate.setDate(oDate.getDate() + (day || 30))
        document.cookie = name + '=' + value + ';expires=' + oDate + "; path=/;"
    },
    get: function(name) {
        let str = document.cookie
        let arr = str.split('; ')
        for (let i = 0; i < arr.length; i++) {
            let newArr = arr[i].split('=')
            if (newArr[0] === name) {
                return newArr[1]
            }
        }
    },
    del: function(name) {
        this.set(name, '', -1)
    }
}
```
# 数字格式化单位
```javascript
/**
 * Number formatting
 * like 10000 => 10k
 * @param {number} num
 * @param {number} digits
 */
export function numberFormatter(num, digits) {
    const si = [{
            value: 1E18,
            symbol: 'E'
        },
        {
            value: 1E15,
            symbol: 'P'
        },
        {
            value: 1E12,
            symbol: 'T'
        },
        {
            value: 1E9,
            symbol: 'G'
        },
        {
            value: 1E6,
            symbol: 'M'
        },
        {
            value: 1E3,
            symbol: 'k'
        }
    ]
    for (let i = 0; i < si.length; i++) {
        if (num >= si[i].value) {
            return (num / si[i].value).toFixed(digits).replace(/\.0+$|(\.[0-9]*[1-9])0+$/, '$1') + si[i].symbol
        }
    }
    return num.toString()
}
```

# 数字千位过滤
```javascript
/**
 * 10000 => "10,000"
 * @param {number} num
 */
export function toThousandFilter(num) {
    let targetNum = (num || 0).toString()
    if (targetNum.includes('.')) {
        let arr = num.split('.')
        return arr[0].replace(/^-?\d+/g, m => m.replace(/(?=(?!\b)(\d{3})+$)/g, ',')) + '.' + arr[1]
    } else {
        return targetNum.replace(/^-?\d+/g, m => m.replace(/(?=(?!\b)(\d{3})+$)/g, ','))
    }
}
```

# 过滤成版本号
```javascript
/**
 * version filter
 * 50397188 => 3.1.0.4
 * @param {number} versions
 */
export function versionFilter(versions) {
    let v0 = (versions & 0xff000000) >> 24
    let v1 = (versions & 0xff0000) >> 16
    let v2 = (versions & 0xff00) >> 8
    let v3 = versions & 0xff
    return `${v0}.${v1}.${v2}.${v3}`
}
```

# 首字母大写
```javascript
/**
 * Upper case first char
 * @param {String} string
 */
export function uppercaseFirst(string) {
    return string.charAt(0).toUpperCase() + string.slice(1)
}
```

# 文本复制功能
```javascript
const copyTxt = function(text, fn) { // 复制功能
    if (typeof document.execCommand !== 'function') {
        console.log('复制失败，请长按复制')
        return
    }
    var dom = document.createElement('textarea')
    dom.value = text
    dom.setAttribute('style', 'display: block;width: 1px;height: 1px;')
    document.body.appendChild(dom)
    dom.select()
    var result = document.execCommand('copy')
    document.body.removeChild(dom)
    if (result) {
        console.log('复制成功')
        typeof fn === 'function' && fn()
        return
    }
    if (typeof document.createRange !== 'function') {
        console.log('复制失败，请长按复制')
        return
    }
    var range = document.createRange()
    var div = document.createElement('div')
    div.innerhtml = text
    div.setAttribute('style', 'height: 1px;fontSize: 1px;overflow: hidden;')
    document.body.appendChild(div)
    range.selectNode(div)
    var selection = window.getSelection()
    console.log(selection)
    if (selection.rangeCount > 0) {
        selection.removeAllRanges()
    }
    selection.addRange(range)
    document.execCommand('copy')
    typeof fn === 'function' && fn()
    console.log('复制成功')
}
```

# 判断是否是一个数组
```javascript
export const castArray = value => (Array.isArray(value) ? value : [value])

export const castArray = arr=>  Object.prototype.toString.call(arr) === '[object Array]'
```

# 判断是否是一个空数组
```javascript
export const isEmpty = (arr) => !Array.isArray(arr) || arr.length === 0
// for example
// isEmpty([]); // true
// isEmpty([1, 2, 3]); // false
```

# 克隆一个数组
```javascript
/**
 * @param {Array} arr 
 */
const clone = (arr) => arr.slice(0);

const clone = (arr) => [...arr];

const clone = (arr) => Array.from(arr);

const clone = (arr) => arr.map((x) => x);

const clone = (arr) => JSON.parse(JSON.stringify(arr));

const clone = (arr) => arr.concat([]);

```

# 数组去重
```javascript
/**
 * @param {Array} arr
 * @returns {Array}
 */
export const uniqueArray = (arr) => Array.from(new Set(arr))

export const uniqueArray = (arr) => arr.filter((el, i, array) => array.indexOf(el) === i)

export const uniqueArray = (arr) => arr.reduce((acc, el) => (acc.includes(el) ? acc : [...acc, el]), [])
```

# 是否为PC端
```javascript
export const isPC = function() { // 是否为PC端
    let userAgentInfo = navigator.userAgent
    let Agents = ['Android', 'iPhone', 'SymbianOS', 'Windows Phone', 'iPad', 'iPod']
    let flag = true
    for (let v = 0; v < Agents.length; v++) {
        if (userAgentInfo.indexOf(Agents[v]) > 0) {
            flag = false
            break
        }
    }
    return flag
}
```

# 判断是否为微信
```javascript
export const isWx = () => { // 判断是否为微信
    var ua = window.navigator.userAgent.toLowerCase()
    if (ua.match(/MicroMessenger/i) === 'micromessenger') {
        return true
    }
    return false
}
```

# 设备判断：android、ios、web
```javascript
export const isDevice = function() { // 判断是android还是ios还是web
    var ua = navigator.userAgent.toLowerCase()
    if (ua.match(/iPhone\sOS/i) === 'iphone os' || ua.match(/iPad/i) === 'ipad') { // ios
        return 'iOS'
    }
    if (ua.match(/Android/i) === 'android') {
        return 'Android'
    }
    return 'Web'
}
```

# 常见正则校验
```javascript
/*正则匹配*/
export const normalReg = (str, type) => {
    switch (type) {
        case 'phone':   //手机号码
            return /^1[3|4|5|6|7|8|9][0-9]{9}$/.test(str);
        case 'tel':     //座机
            return /^(0\d{2,3}-\d{7,8})(-\d{1,4})?$/.test(str);
        case 'card':    //身份证
            return /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/.test(str);
        case 'pwd':     //密码以字母开头，长度在6~18之间，只能包含字母、数字和下划线
            return /^[a-zA-Z]\w{5,17}$/.test(str)
        case 'postal':  //邮政编码
            return /[1-9]\d{5}(?!\d)/.test(str);
        case 'QQ':      //QQ号
            return /^[1-9][0-9]{4,9}$/.test(str);
        case 'email':   //邮箱
            return /^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$/.test(str);
        case 'money':   //金额(小数点2位)
            return /^\d*(?:\.\d{0,2})?$/.test(str);
        case 'URL':     //网址
            return /(http|ftp|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&:/~\+#]*[\w\-\@?^=%&/~\+#])?/.test(str)
        case 'IP':      //IP
            return /((?:(?:25[0-5]|2[0-4]\\d|[01]?\\d?\\d)\\.){3}(?:25[0-5]|2[0-4]\\d|[01]?\\d?\\d))/.test(str);
        case 'date':    //日期时间
            return /^(\d{4})\-(\d{2})\-(\d{2}) (\d{2})(?:\:\d{2}|:(\d{2}):(\d{2}))$/.test(str) || /^(\d{4})\-(\d{2})\-(\d{2})$/.test(str)
        case 'number':  //数字
            return /^[0-9]$/.test(str);
        case 'positiveInteger':  //正整数
            return /^[1-9]\d*$/.test(str);
        case 'price':  //价格
            return /(^[1-9]\d*(\.\d{1,2})?$)|(^0(\.\d{1,2})?$)/.test(str);//价格非0则去掉'?'
        case 'english': //英文
            return /^[a-zA-Z]+$/.test(str);
        case 'chinese': //中文
            return /^[\u4E00-\u9FA5]+$/.test(str);
        case 'lower':   //小写
            return /^[a-z]+$/.test(str);
        case 'upper':   //大写
            return /^[A-Z]+$/.test(str);
        case 'HTML':    //HTML标记
            return /<("[^"]*"|'[^']*'|[^'">])*>/.test(str);
        default:
            return true;
    }
}
```

# 去除字符串空格
```javascript
/**
 * @param {str} str
 * @param {Number} type 1 -> 所有空格  2 -> 前后空格  3 -> 前空格 4 -> 后空格
 * @returns {String} 
 */
export const trim = function(str, type) { 
    type = type || 1
    switch (type) {
        case 1:
            return str.replace(/\s+/g, '')
        case 2:
            return str.replace(/(^\s*)|(\s*$)/g, '')
        case 3:
            return str.replace(/(^\s*)/g, '')
        case 4:
            return str.replace(/(\s*$)/g, '')
        default:
            return str
    }
}
```

# 过滤html代码
```javascript
export const filterTag = function(str) { // 过滤html代码(把<>转换)
    str = str.replace(/&/ig, '&')
    str = str.replace(/</ig, '<')
    str = str.replace(/>/ig, '>')
    str = str.replace(' ', ' ')
    return str
}
```

# 生成随机数范围
```javascript
export const random = function(min, max) { // 生成随机数范围
    if (arguments.length === 2) {
        return Math.floor(min + Math.random() * ((max + 1) - min))
    } else {
        return null
    }
}
```

# 判断图片加载完成
```javascript
export const imgLoadAll = function(arr, callback) { // 图片加载
    let arrImg = []
    for (let i = 0; i < arr.length; i++) {
        let img = new Image()
        img.src = arr[i]
        img.onload = function() {
            arrImg.push(this)
            if (arrImg.length == arr.length) {
                callback && callback()
            }
        }
    }
}
```

# 图片地址转base64
```javascript
export const getBase64 = function(img) { 
    //传入图片路径，返回base64，使用getBase64(url).then(function(base64){},function(err){}); 
    let getBase64Image = function(img, width, height) { 
    //width、height调用时传入具体像素值，控制大小,不传则默认图像大小
        let canvas = document.createElement("canvas");
        canvas.width = width ? width : img.width;
        canvas.height = height ? height : img.height;
        let ctx = canvas.getContext("2d");
        ctx.drawImage(img, 0, 0, canvas.width, canvas.height);
        let dataURL = canvas.toDataURL();
        return dataURL;
    }
    let image = new Image();
    image.crossOrigin = '';
    image.src = img;
    let deferred = $.Deferred();
    if (img) {
        image.onload = function() {
            deferred.resolve(getBase64Image(image));
        }
        return deferred.promise();
    }
}
```

# base64图片下载功能
```javascript
export const downloadFile  = (base64, fileName) => {
    let base64ToBlob = (code) => {
        let parts = code.split(';base64,');
        let contentType = parts[0].split(':')[1];
        let raw = window.atob(parts[1]);
        let rawLength = raw.length;
        let uInt8Array = new Uint8Array(rawLength);
        for (let i = 0; i < rawLength; ++i) {
            uInt8Array[i] = raw.charCodeAt(i);
        }
        return new Blob([uInt8Array], {
            type: contentType
        });
    };
    let aLink = document.createElement('a');
    let blob = base64ToBlob(base64); //new Blob([content]);
    let evt = document.createEvent("HTMLEvents");
    evt.initEvent("click", true, true); //initEvent不加后两个参数在FF下会报错  事件类型，是否冒泡，是否阻止浏览器的默认行为
    aLink.download = fileName;
    aLink.href = URL.createObjectURL(blob);
    aLink.click();
}
```

# 浏览器是否支持webP格式图片
```javascript
export const webPBool = () => !![].map && document.createElement('canvas').toDataURL('image/webp').indexOf('data:image/webp') == 0
```

# H5软键盘缩回、弹起回调
```javascript
/* 当软件键盘弹起会改变当前 window.innerHeight
监听这个值变化 [downCb 当软键盘弹起后，缩回的回调,upCb 当软键盘弹起的回调] */
export function(downCb, upCb) { 
    var clientHeight = window.innerHeight
    downCb = typeof downCb === 'function' ? downCb : function() {}
    upCb = typeof upCb === 'function' ? upCb : function() {}
    window.addEventListener('resize', () => {
        var height = window.innerHeight
        if (height === clientHeight) {
            downCb()
        }
        if (height < clientHeight) {
            upCb()
        }
    })
}
```

# 对象属性剔除
```javascript
/** 
* @param {object} object 
* @param {string[]} props 
* @return {object} 
*/
function omit(object, props=[]){  
    let res = {}  
    Object.keys(object).forEach(key=>{    
        if(props.includes(key) === false){      
            res[key] = typeof object[key] === 'object' && object[key] !== null ? jsON.parse(jsON.stringify(object[key])) : object[key]    
        }  
    })         
    return res
}

// for example
let data = {  id: 1,  title: '12345',  name: '男'}
omit(data, ['id']) 
// data ---> {title: 'xxx', name: '男'}
```

# 深拷贝
```javascript
/**
 * This is just a simple version of deep copy
 * Has a lot of edge cases bug
 * If you want to use a perfect deep copy, use lodash's _.cloneDeep
 * @param {Object} source
 * @returns {Object}
 */
export function deepClone(source) {
    if (!source && typeof source !== 'object') {
        throw new Error('error arguments', 'deepClone')
    }
    const targetObj = source.constructor === Array ? [] : {}
    Object.keys(source).forEach(keys => {
        if (source[keys] && typeof source[keys] === 'object') {
            targetObj[keys] = deepClone(source[keys])
        } else {
            targetObj[keys] = source[keys]
        }
    })
    return targetObj
}
```

# 函数防抖
```javascript 
export function debounce(func, wait, immediate) {
    let timeout, args, context, timestamp, result
    const later = function() {
        // 据上一次触发时间间隔
        const last = +new Date() - timestamp

        // 上次被包装函数被调用时间间隔 last 小于设定时间间隔 wait
        if (last < wait && last > 0) {
            timeout = setTimeout(later, wait - last)
        } else {
            timeout = null
            // 如果设定为immediate===true，因为开始边界已经调用过了此处无需调用
            if (!immediate) {
                result = func.apply(context, args)
                if (!timeout) context = args = null
            }
        }
    }
    return function(...args) {
        context = this
        timestamp = +new Date()
        const callNow = immediate && !timeout
        // 如果延时不存在，重新设定延时
        if (!timeout) timeout = setTimeout(later, wait)
        if (callNow) {
            result = func.apply(context, args)
            context = args = null
        }
        return result
    }
}
```

# 函数节流
```javascript 
/**
 * @param {Function} func 目标函数
 * @param {Number} wait  延迟执行毫秒数
 * @param {Number} type  type 1 表时间戳版，2 表定时器版
 */
export function throttle(func, wait ,type) { 
    if(type===1){
        let previous = 0;
    }else if(type===2){
        let timeout;
    }
    return function() {
        let context = this;
        let args = arguments;
        if(type===1){
            let now = Date.now();
            if (now - previous > wait) {
                func.apply(context, args);
                previous = now;
            }
        }else if(type===2){
            if (!timeout) {
                timeout = setTimeout(() => {
                    timeout = null;
                    func.apply(context, args)
                }, wait)
            }
        }
    }
}
```

# 对象数组分组（同一对象）
```javascript
const people = [
  {name: 'test1', age: 25, sex:'male', tel: '17853538076'},
  {name: 'test2', age: 23, sex:'female', tel: '17853538071'},
  {name: 'test3', age: 22, sex:'male', tel: '17853538072'},
  {name: 'test4', age: 25, sex:'female', tel: '17853538073'},
  {name: 'test5', age: 22, sex:'male', tel: '17853538077'}
]
function groupBy(arr, propName) {
  const result = {};
  for (const item of arr) {
    const key = item[propName];
    if (!result[key]) {
      result[key] = [];
    }
    result[key].push(item);
  }
  return result;
}
// 根据姓名分组
groupBy(people, 'sex');
// 根据年龄分组
groupBy(people, 'age');

```

# 对象数组分组（不同对象）
```javascript
const people = [
  {name: 'test1', age: 25, sex:'male', tel: '17853538076', address: {
    provice: '山东省',
    city: '聊城市'
  }},
  {name: 'test2', age: 23, sex:'female', tel: '17853538071', address: {
    provice: '山东省',
    city: '烟台市'
  }},
  {name: 'test3', age: 22, sex:'male', tel: '17853538072', address: {
    provice: '山东省',
    city: '聊城市'
  }},
  {name: 'test4', age: 25, sex:'female', tel: '17853538073', address: {
    provice: '山东省',
    city: '聊城市'
  }},
  {name: 'test5', age: 22, sex:'male', tel: '17853538077', address: {
    provice: '山东省',
    city: '烟台市'
  }}
]
function groupBy(arr, generateKey) {
  if (typeof generateKey === 'string') {
    const propName = generateKey;
    generateKey = (item) => item[propName];
  }
  const result = {};
  for (const item of arr) {
    const key = generateKey(item);
    if (!result[key]) {
      result[key] = [];
    }
    result[key].push(item);
  }
  return result;
}
// 根据年龄分组
groupBy(people, 'age');

// 根据年龄性别分组
groupBy(people, (item) => `${item.age}-${item.sex}`);

// 根据省份分组
groupBy(people, (item) => item.address.provice);

// 根据城市分组
groupBy(people, (item) => item.address.city);
```
