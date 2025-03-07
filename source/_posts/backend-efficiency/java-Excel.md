---
title: Java实战之自定义注解（以excel导出为案例）
date: 2024/09/10
tags: [Java,excel,AOP]
categories: 后端-开发效率
description: 在java中，注解其实就是一个标识，他可以标注类、方法、字段。然后我们可以通过反射判断该类、方法、字段上面有没有该注解，并同时可以获取注解设置的值。在我们的项目中，往往会和aop联合使用，去做一些日志打印或者容器初始化工作等等。
cover: /img/md/java.png
---

# 定义注解@Excel、@PrintExcelLog。
- @Excel用于设置excel的标题和默认值
- @PrintExcelLog用于标识是否打印excel导出日志
```java
/**
 * 用于设置excel的标题和默认值
 */
@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.FIELD, ElementType.METHOD, ElementType.TYPE})
@Component
public @interface Excel {
 
    String title() default "";
 
    String value() default "";
}
```j
```java
/**
 * 用于标识是否打印excel导出日志
 */
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
public @interface PrintExcelLog {
 
    boolean value() default true;
 
}
```
其中@Retention是用来定义生命周期，我们这里是运行时；
@Target表示作用目标，有以下8种：
ElementType.TYPE: 可以应用于类、接口、枚举（enum）。
ElementType.FIELD: 可以应用于字段（包括枚举常量）。
ElementType.METHOD: 可以应用于方法。
ElementType.PARAMETER: 可以应用于方法的参数。
ElementType.CONSTRUCTOR: 可以应用于构造方法。
ElementType.LOCAL_VARIABLE: 可以应用于局部变量。
ElementType.ANNOTATION_TYPE: 可以应用于注解类型。
ElementType.PACKAGE: 可以应用于包。

# 创建实体类
创建一个用户类和用户性别枚举，并加上@Excel注解指定excel的标题和默认值
```java
/**
 * 用户
 */
@Data
public class User {
 
    // 唯一标识
    private String id;
 
    @Excel(title = "姓名")
    private String name;
 
    @Excel(title = "年龄")
    private int age;
 
    /**
     * 性别 0-女 1-男
     */
    @Excel(title = "性别", value = "未知")
    private int gender;
 
    public User(String name, int age, int gender) {
        this.name = name;
        this.age = age;
        this.gender = gender;
    }
}
```
```java
/**
 * 性别
 */
@Getter
public enum Gender {
    MALE(1, "男"),
    FEMALE(0, "女"),
    UNKNOWN(2, "未知")
 
    ;
 
    private final int code;
    private final String description;
 
    Gender(int code, String description) {
        this.code = code;
        this.description = description;
    }
 
    public static String getDescriptionByCode(int code) {
        for (Gender gender : Gender.values()) {
            if (code == gender.code) {
                return gender.description;
            }
        }
        throw new RuntimeException("编码不存在！");
    }
}
```

# 创建工具类
创建excel导出工具类，这里我们使用的是XssWorkbook这个工具类，通过反射获取注解的title值之后设置给excel的cellValue。并且对于性别我们需要把0、1转换成男、女，默认未知。
```java
/**
 * excel导出工具类
 */
@Component
public class ExcelExportUtil {
 
    @PrintExcelLog
    public void exportUserData(List<User> userList, OutputStream outputStream) {
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet();
 
            // 写入标题行
            Row row = sheet.createRow(0);
            Field[] declaredFields = User.class.getDeclaredFields();
            int columnIndex = 0;
            for (Field field : declaredFields) {
                if (field.isAnnotationPresent(Excel.class)) {
                    String title = field.getAnnotation(Excel.class).title();
                    Cell cell = row.createCell(columnIndex++);
                    cell.setCellValue(title);
                }
            }
 
            // 写入数据行
            for (int i = 0; i < userList.size(); i++) {
                // 从第二行开始写数据
                Row userRow = sheet.createRow(i + 1);
                writeRowData(userRow, userList.get(i));
            }
 
            workbook.write(outputStream);
 
        } catch (IOException | IllegalAccessException e) {
            throw new RuntimeException(e);
        }
    }
 
    private static void writeRowData(Row userRow, User user) throws IllegalAccessException {
        Field[] fields = User.class.getDeclaredFields();
        int columnIndex = 0;
        for (Field field : fields) {
            if (field.isAnnotationPresent(Excel.class)) {
                field.setAccessible(true);
                Cell cell = userRow.createCell(columnIndex++);
                String value = field.getAnnotation(Excel.class).value();
 
                // 如果为性别字段，通过枚举转换为男/女
                if (StringUtils.hasLength(value)) {
                    String description = Gender.getDescriptionByCode(user.getGender());
                    cell.setCellValue(description);
                } else {
                    cell.setCellValue(String.valueOf(field.get(user)));
                }
 
                field.setAccessible(false);
            }
        }
    }
}
```

# 实现AOP
对方法exportUserData()进行aop，获取它的参数值及注解信息，打印相关日志。
```java
@Slf4j
@Aspect
@Component
public class GenderAspect {
 
    @Pointcut("execution(* com.xxl.job.admin.annotationdemo.util.ExcelExportUtil.exportUserData(..))")
    public void setGenderValue() {
 
    }
 
    @Around("setGenderValue()")
    public Object doSetGenderValue(ProceedingJoinPoint point) {
        // 获取用户信息
        List<?> userList = new ArrayList<>();
        Object[] args = point.getArgs();
        if (args != null && args.length > 0 && args[0] instanceof List) {
            userList = (List<?>) args[0];
        }
        // 获取注解信息
        MethodSignature signature = (MethodSignature) point.getSignature();
        Method method = signature.getMethod();
        PrintExcelLog annotation = method.getAnnotation(PrintExcelLog.class);
        // 打印日志
        if (Objects.nonNull(annotation) && annotation.value()) {
            userList.forEach(user -> log.info("正在进行Excel导出，用户信息为：{}, 当前时间：{}", user, LocalDateTime.now()));
        }
        try {
            return point.proceed();
        } catch (Throwable e) {
            e.printStackTrace();
        }
        return null;
    }
}
```

# 测试
```java
@RestController
@RequestMapping("/test")
public class test {
    @Autowired
    private ExcelExportUtil excelExportUtil;
 
    @GetMapping("/userDataExport")
    public void userDataExport() throws IOException {
        List<User> users = List.of(
                new User("张三", 20, 1),
                new User("李四", 30, 0),
                new User("王五", 40, 1)
        );
        OutputStream outputStream = Files.newOutputStream(Paths.get("F:\\Edge\\springcloud-hrm-master\\xxl-job\\xxl-job-admin\\target\\users.xlsx"));
        excelExportUtil.exportUserData(users, outputStream);
    }
 
}
```
# 最终效果
![文件效果](/img/md/java-Excel/fe72ed0db3ec4dcfb750fb11bb2f031d.png)
![log打印](/img/md/java-Excel/d05a9d3d05804653af8ca05a1ae3cf39.png)