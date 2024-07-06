---
title: CSS 布局
date: 2021/05/24
tags: CSS,布局
categories: CSS
description: 布局是把页面分成一块一块，按左中右、上中下等排列。
keywords: CSS,布局
cover: /img/md/css.jpg
---

# 圣杯布局

- 左右两栏 上下高度自适应
- 中间一栏 宽度自适应

![圣杯布局](/img/md/pictures/css-layout1.png)

## float版本

```html
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Title</title>
	<style type="text/css">
		/* reset */
		html, body {
			margin: 0;
			padding: 0;
			height: 100%;
			max-height: 100%;
		}
		body {
			min-width: 600px;
			min-height: 400px;
			font-size: 32px;
		}
		/* 修饰代码 */
		#left ul, #right ul {
			list-style: decimal;
			padding-inline-start: 0;
			padding: 0px 40px;
			overflow: auto;
		}
		#left ul li, #right ul li {
			font-size: 20px;
			line-height: 2;
			margin-bottom: 10px;
		}
		#center p {
			line-height: 3;
			color: #555555;
			padding: 20px;
			font-size: 30px;
		}

		/* 圣杯布局核心 */
		#header {
			text-align: center;
			background-color: #f1f1f1;
			height: 50px;
		}
		#container {
			height: calc(100% - 100px);
			padding: 0 150px 0 200px;
		}
		#container .column {
			float: left;
		}
		#center {
			background-color: #ccc;
			width: 100%;
			height: 100%;
			overflow: auto;
		}
		#right, #left {
			position: relative;
			overflow: auto;
			height: 100%;
		}
		#left {
			background-color: #ffff66;
			width: 200px;
			margin-left: -100%;
			right: 200px
		}
		#right {
			background-color: #ff7777;
			width: 150px;
			margin-right: -150px;
		}
		#footer {
			clear: both;
			text-align: center;
			background-color: #f1f1f1;
			height: 50px;
		}
	</style>
</head>
<body>
		<header id="header">header</header>
		<section id="container">
			<div id="center" class="column">
				<h2>center</h2>
				<p>这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容
					这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容
					这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容
					这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容
					这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容</p>
			</div>
			<div id="left" class="column">
				<ul>
					<li>菜单</li>
					<li>菜单</li>
					<li>菜单</li>
					<li>菜单</li>
					<li>菜单</li>
					<li>菜单</li>
					<li>菜单</li>
					<li>菜单</li>
					<li>菜单</li>
					<li>菜单</li>
					<li>菜单</li>
					<li>菜单</li>
					<li>菜单</li>
				</ul>
			</div>
			<div id="right" class="column">right</div>
		</section>
		<footer id="footer">footer</footer>
</body>
</html>
```

## float版本

```html
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Title</title>
	<style type="text/css">
		/* reset */
		html, body {
			margin: 0;
			padding: 0;
			height: 100%;
		}
		body {
			min-width: 600px;
			min-height: 400px;
			font-size: 32px;
		}
		/* 修饰代码 */
		#left ul, #right ul {
			list-style: decimal;
			padding-inline-start: 0;
			padding: 0px 40px;
			overflow: auto;
		}
		#left ul li, #right ul li {
			font-size: 20px;
			line-height: 2;
			margin-bottom: 10px;
		}
		#center p {
			line-height: 3;
			color: #555555;
			padding: 20px;
			font-size: 30px;
		}

		/* 圣杯布局核心 */
		body {
			display: flex;
			flex-direction: column;
			height: 100%;
		}
		#header {
			text-align: center;
			background-color: #f1f1f1;
			height: 50px;
			flex: none;
		}
		#container {
			flex: auto;
			display: flex;
			overflow-y: auto;
		}
		#center {
			background-color: #ccc;
			overflow-y: auto;
		}
		#right, #left {
			flex: none;
			align-items: stretch;
			height: 100%;
			overflow-y: auto;
		}
		#left {
			background-color: #ffff66;
			width: 200px;
		}
		#right {
			background-color: #ff7777;
			width: 150px;
		}

		#footer {
			clear: both;
			text-align: center;
			background-color: #f1f1f1;
			height: 50px;
			flex: none;
		}
	</style>
</head>
<body>
<header id="header">header</header>
<section id="container">
	<div id="left" class="column">
		<ul>
			<li>菜单</li>
			<li>菜单</li>
			<li>菜单</li>
			<li>菜单</li>
			<li>菜单</li>
			<li>菜单</li>
			<li>菜单</li>
			<li>菜单</li>
			<li>菜单</li>
			<li>菜单</li>
			<li>菜单</li>
			<li>菜单</li>
			<li>菜单</li>
		</ul>
	</div>
	<div id="center" class="column">
		<h2>center</h2>
		<p>这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容
			这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容
			这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容
			这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容
			这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容</p>
	</div>
	<div id="right" class="column">right</div>
</section>
<footer id="footer">footer</footer>
</body>
</html>
```

## grid版本

```html
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>圣杯布局</title>
	<style type="text/css">
		/* reset */
		html, body {
			margin: 0;
			padding: 0;
			height: 100%;
		}
		body {
			min-width: 600px;
			min-height: 400px;
			font-size: 32px;
		}
		/* 修饰代码 */
		#left ul, #right ul {
			list-style: decimal;
			padding-inline-start: 0;
			padding: 0px 40px;
			overflow: auto;
		}
		#left ul li, #right ul li {
			font-size: 20px;
			line-height: 2;
			margin-bottom: 10px;
		}
		#center p {
			line-height: 3;
			color: #555555;
			padding: 20px;
			font-size: 30px;
		}
		#header {
			background-color: #f1f1f1;
		}
		#center {
			background-color: #ccc;
		}
		#left {
			background-color: #ffff66;
		}
		#right {
			background-color: #ff7777;
		}

		/* 圣杯布局核心 */
		body {
			display: grid;
			grid-column: 3;
			flex-direction: column;
			grid-template-columns: 200px auto 200px;
			grid-template-rows: 100px auto 100px;
			place-items: stretch stretch; /* align-items: stretch; justify-items: stretch; */
			max-height: 100%;
		}
		#header, #footer {
			grid-column-start: 1;
			grid-column-end: 4;
			text-align: center;
		}
		#left, #center, #right {
			overflow-y: auto;
		}
	</style>
</head>
<body>
	<header id="header">header</header>
	<div id="left">
		<ul>
			<li>菜单</li>
			<li>菜单</li>
			<li>菜单</li>
			<li>菜单</li>
			<li>菜单</li>
			<li>菜单</li>
			<li>菜单</li>
			<li>菜单</li>
			<li>菜单</li>
			<li>菜单</li>
			<li>菜单</li>
			<li>菜单</li>
			<li>菜单</li>
		</ul>
	</div>
	<div id="center">
		<h2>center</h2>
		<p>这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容
			这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容
			这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容
			这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容
			这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容</p>
	</div>
	<div id="right">right</div>
	<footer id="footer">footer</footer>
</body>
</html>
```

# 双飞翼布局

- 容器高度自适应
- 左右两栏上下自适应
- 中间宽度和高度自适应


![双飞翼布局](/img/md/pictures/css-layout2.png)

## float版本

```html
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Title</title>
	<style type="text/css">
		/* reset */
		html, body {
			margin: 0;
			padding: 0;
		}
		body {
			min-width: 600px;
			min-height: 400px;
			font-size: 32px;
		}
		
		/* 双飞布局核心代码 */
		.col {
			float: left;
		}
		#main {
			width: 100%;
			height: 200px;
			background-color: #ccc;
		}
		#main-wrap {
			margin: 0 200px;
		}
		#left {
			position: relative;
			width: 200px;
			height: 200px;
			background-color: #33f;
			margin-left: -100%;
		}
		#right {
			width: 200px;
			height: 200px;
			background-color: #f33;
			margin-left: -200px;
		}
	</style>
</head>
<body>
	<div id="main" class="col">
		<div id="main-wrap">
			main
		</div>
	</div>
	<div id="left" class="col">left</div>
	<div id="right" class="col">right</div>
</body>
</html>
```

## flex版本

```html
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Title</title>
	<style type="text/css">
		/* reset */
		html, body {
			margin: 0;
			padding: 0;
			height: 100%;
			max-height: 100%;
		}
		body {
			min-width: 600px;
			min-height: 400px;
			font-size: 32px;
		}
		/* 样式修饰 */
		#left ul, #right ul {
			list-style: decimal;
			padding-left: 50px;
		}
		#main {
			padding: 20px;
			color: #888888;
		}

		/* 双飞翼布局核心 */
		body {
			height: 300px;
			display: flex;
			overflow-y: auto;
			align-items: stretch;
		}
		#main {
			flex: auto;
			background-color: #cccccc;
			overflow-y: auto;
		}
		#left, #right {
			flex: none;
			width: 150px;
			overflow-y: auto;
		}
		#right {
			background-color: antiquewhite;
		}
		#left {
			background-color: cornflowerblue;
		}
	</style>
</head>
<body>
	<div id="left">
		<ul>
			<li>菜单</li>
			<li>菜单</li>
			<li>菜单</li>
			<li>菜单</li>
			<li>菜单</li>
			<li>菜单</li>
			<li>菜单</li>
			<li>菜单</li>
			<li>菜单</li>
		</ul>
	</div>
	<div id="main">
		<h2>main</h2>
		<p>这是一段文字内容这是一段文字内容这是一段文字内容这是一段文字内容这是一段文字内容这是一段文字内容
			这是一段文字内容这是一段文字内容这是一段文字内容这是一段文字内容这是一段文字内容这是一段文字内容</p>
	</div>
	<div id="right">right</div>
</body>
</html>
```

## grid版本

```html
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Title</title>
	<style type="text/css">
		/* reset */
		html, body {
			margin: 0;
			padding: 0;
		}
		body {
			min-width: 600px;
			min-height: 400px;
			font-size: 32px;
		}
		#main {
			background-color: #ccc;
		}
		#left {
			background-color: #33f;
		}
		#right {
			background-color: #f33;
		}

		/* 双飞布局核心代码 */
		body {
			display: grid;
			grid-template-columns: 200px auto 200px;
		}

	</style>
</head>
<body>
	<div id="left">left</div>
	<div id="center">center</div>
	<div id="right">right</div>
</body>
</html>
```

# 居中布局

## 水平居中
- 子容器高度宽度自适应

![水平居中](/img/md/pictures/css-layout3.png)

```html
<!doctype html>
<html lang="zh">
<head>
	<meta charset="UTF-8">
	<title>水平居中</title>
	<style>
		/* 修饰代码 */
		html, body {
			height: 100%;
		}
		.container {
			height: 240px;
			width: 400px;
			margin: 10px;
			background-color: #eeeeee;
			float: left;
		}
		.box {
			background-color: #fff;
			border: 1px solid #3333ff;
		}

		/* 水平居中核心代码（容器宽度不确定）*/
		/* 方案1 */
		.box1 {
			height: 50%;
			width: 50%;
			margin: 0 auto;
		}
		/* 方案2 */
		.box2 {
			display: table;
			margin: 0 auto
		}
		/*方案三*/
		.container3 {
			position: relative;
		}
		.box3 {
			position: absolute;
			left: 50%;
			transform: translateX(-50%);
		}
		/*方案四*/
		.container4 {
			overflow: hidden;
		}
		.box4 {
			float: left;
			margin-left:  50%;
			transform: translateX(-50%);
		}
		/*方案五*/
		.container5 {
			display: flex;
			justify-content: center;
		}
		.box5 {
			flex: none;
			display: flex;
			align-self: flex-start;
		}
		/*方案六*/
		.container6 {
			display: grid;
			justify-content: center;
		}
		.box6 {
			align-self: flex-start;
		}
	</style>
</head>
<body>
	<h2>水平居中（容器）的实现方式</h2>
	<div class="container">
		<div class="box box1">
			方式一 <br>{margin: 0 auto;}
			<br>
			缺点是需要手动指定自容器宽度和高度
		</div>
	</div>

	<div class="container container2">
		<div class="box box2">
			方式二： <br>{margin:0 auto;}改进
			<br>
			子容器设置display: table，子容器会自适应
			<br>
			该方案兼容性好，改成table标签即可兼容IE
		</div>
	</div>

	<div class="container container3">
		<div class="box box3">
			方式三： 绝对定位
			<br>
		</div>
	</div>

	<div class="container container4">
		<div class="box box4">
			方式四： 浮动和margin
		</div>
	</div>

	<div class="container container5">
		<div class="box box5">
			方式五： flex
		</div>
	</div>

	<div class="container container6">
		<div class="box box6">
			方式6：grid
		</div>
	</div>
</body>
</html>
```

## 垂直居中
- 子容器高度、宽度自适应

![垂直居中](/img/md/pictures/css-layout4.png)


方案三算一种方式是因为，方式二中transform 是 css3样式在古老的浏览器上存在兼容问题，后面就不再提这种方式

```html
<!doctype html>
<html lang="zh">
<head>
	<meta charset="UTF-8">
	<title> 垂直居中 </title>
	<style>
		/* 修饰代码 */
		html, body {
			height: 100%;
		}
		.container {
			height: 240px;
			width: 400px;
			margin: 10px;
			background-color: #eeeeee;
			float: left;
		}
		.box {
			background-color: #fff;
			border: 1px solid #3333ff;
		}

		/* 垂直居中核心代码（容器高度不确定）*/
		/* 方案1 */
		.container1 {
			display: table;
		}
		.box-wrapper1 {
			display: table-cell;
			vertical-align: middle;
		}
		.box1 {
			display: inline-block;
		}
		/* 方案2 */
		.container2 {
			position: relative;
		}
		.box2 {
			position: absolute;
			top: 50%;
			transform: translateY(-50%);
		}
		/* 方案3 */
		.container3 {
			position: relative;
		}
		.box3 {
			position: absolute;
			top: 0;
			bottom: 0;
			height:50px;
			margin: auto 0;
		}
		/* 方案4 */
		.container4 {
			display: flex;
			align-items: center;
		}
		/* 方案5 */
		.container5 {
			display: grid;
			align-items: center;
		}
		.box5 {
			justify-self: flex-start;
		}
	</style>
</head>
<body>
	<h2>垂直居中（容器）的实现方式</h2>
	<div class="container container1">
		<div class="box-wrapper1">
			<div class="box box1">
				方式一 display: table<br>
				<br>
				该方案兼容性最好，<br>
				换成table标签即可支持IE
			</div>
		</div>
	</div>
	<div class="container container2">
		<div class="box box2">
			方式二 绝对定位
		</div>
	</div>
	<div class="container container3">
		<div class="box box3">
			方式三 绝对定位 + margin
			<br>
			缺点：要给容器设置高度
		</div>
	</div>
	<div class="container container4">
		<div class="box box4">
			方案四 flex
		</div>
	</div>
	<div class="container container5">
		<div class="box box5">
			方案五 grid
		</div>
	</div>
</body>
</html>
```

## 水平垂直居中
- 子容器的高度自适应

![水平垂直居中](/img/md/pictures/css-layout5.png)


```html
<!doctype html>
<html lang="zh">
<head>
	<meta charset="UTF-8">
	<title>水平居中</title>
	<style>
		/* 修饰代码 */
		html, body {
			height: 100%;
		}
		.container {
			height: 240px;
			width: 400px;
			margin: 10px;
			background-color: #eeeeee;
			float: left;
		}
		.box {
			background-color: #fff;
			border: 1px solid #3333ff;
		}

		/* 水平垂直居中核心代码（容器宽度宽度都不确定）*/
		/* 方案1 */
		.container1 {
			display: table;
		}
		.box-wrapper1 {
			display: table-cell;
			vertical-align: middle;
			text-align: center;
		}
		.box1 {
			display: inline-block;
		}
		/* 方案2 */
		.container2 {
			position: relative;
		}
		.box2 {
			position: absolute;
			top: 50%;
			left: 50%;
			transform: translate(-50%, -50%);
		}
		/* 方案3 */
		.container3 {
			display: flex;
			justify-content: center;
			align-items: center;
		}
		/* 方案4 */
		.container4 {
			display: grid;
			justify-content: center;
			align-items: center;
		}
	</style>
</head>
<body>
	<h2>水平居中（容器）的实现方式</h2>
	<div class="container container1">
		<div class="box-wrapper1">
			<div class="box box1">
				方式一 display: table;
			</div>
		</div>
	</div>
	<div class="container container2">
		<div class="box box2">
			方式二 绝对定位
		</div>
	</div>
	<div class="container container3">
		<div class="box">
			方式三 flex
		</div>
	</div>
	<div class="container container4">
		<div class="box">
			方式四 grid
		</div>
	</div>
</body>
</html>
```