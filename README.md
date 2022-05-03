# Gradle SpringBoot Demo
Spring InitializerでGenerateする。  
IntelliJ IDEAで開くときには"build.gradle"を選択して開く

# Annotation
* @Controller：コントローラーとして使用クラスに使用 
* @ResponseBody：メソッドの返り値がそのままHttpResponseとして扱われる
* @GetMapping：GetRequestと処理を紐づける

# Dependenciesの追加
build.gradleのdependencies{...}に追記する  
Spring Initializerで対象のDependenciesを選択後にExploreで内容を確認してコピペ！

# Spring Boot Devtoolsの導入
再ビルドしなくても変更時に自動ビルドが走るようなツール
1. 以下をbuild.gradle > dependenciesに追記
```gradle
developmentOnly 'org.springframework.boot:spring-boot-devtools'
```
2. IntelliJ IDEA > Preference > ビルド実行デプロイ > コンパイラ > 自動的にプロジェクトをビルドするにチェックを入れる
3. IntelliJ IDEA > Preference > 詳細設定 > コンパイラ > 自動Makeの開始を可能にするにチェックを入れる

# Templatesの反映のための再実行をスキップ
以下をapplication.propertiesに追記する
```build
spring.thymeleaf.prefix=file:src/main/resources/templates/
```

# Thymeleafを使用するために
以下をthymeleaf公式サイトから引っ張ってきて貼り付ける
```html
<html xmlns:th="http://www.thymeleaf.org">
```

# Lombokの導入
Spring InitializerでDependenciesを参照して追加
```gradle
# build.gradle

configurations {
	compileOnly {
		extendsFrom annotationProcessor
	}
}

dependencies { 
    compileOnly 'org.projectlombok:lombok'
	annotationProcessor 'org.projectlombok:lombok'
}

```

# Lombok コンストラクタ・ゲッタ・セッタの設定
```java
@AllArgsConstructor
@Data
public class issueEntity {
    private long id;
    private String summary;
    private String description;
}
```
上記のようなアノテーションを追加するだけで、クラスの全てのフィールドを受け取るコンストラクタの作成(@AllArgsConstructor)  
全てのフィールドのgetter, setterを作成(@Data)  
@RequiredArgsConstructor: final かつ初期値のないものをコンストラクタ引数で受け取る  
詳細はLombok公式より参照

# DI(Dependency Injection)依存性の注入
以下のコードのようにクラス内でNewしない（インスタンスを生成しない）ことにより疎結合になる。  
外部から指定の引数を渡せば動作するため拡張性もあり、テストがしやすい。  

SpringでDIを使うにははBeanの登録とインジェクションの登録が必要  
DIContainerにBeanを登録することで、Beanの生成処理やインジェクションをDIコンテナに委譲することができる。

Bean登録したいクラスに以下のアノテーションをつける
* @Component：Beanであることを示す
* @Controller：プレゼンテーション層
* @Service：ビジネスロジック層
* @Repository：データアクセス層
* @Beanもある

```java
// NOT DI : newしている
@Controller
public class SampleController {
    private final SampleService sampleService = new SampleService();
}

// DI : コンストラクタで受け取るのでnewしない
@Controller
public class SampleController {
    private final SampleService sampleService;
    
    public sampleController(SampleService sampleService) {
        this.sampleService = sampleService;
    }
}
```

# H2データベース
インメモリデータベースで開発環境なら使えそう

# MyBatis Framework
Repositoryクラスにアノテーションを追加することで使用できる  
@Mapperを使うことでBean登録も行ってくれる
```java

@Mapper
public interface issueRepository {
    @Select("select * from issues")
    List<issueEntity> findAll();
}
```

# 二重サブミット問題
ポスト→リロード→リロードで登録が繰り返されてしまう。  
ブラウザのリロードが直前のリクエストを再実行するため、直前にPOSTしてあった場合に再POSTされる。  

## PRGパターン(Post Redirect Get)
* PRGパターンなしの場合はリロードのたびに再POSTされる
```
POST /issues ->
<- 200 OK
-----RELOAD
POST /issues ->
<- 200 OK
```
* PRGパターンありの場合は一度GETリクエストを挟んでいるのでPOSTされることがない
```
POST /issues ->
<- 302 REDIRECT
GET /issues ->
<- 200 OK
-----RELOAD
GET /issues ->
<- 200 OK
```

# Thymeleaf Fragments (Template Layout)

```html
<!--フラグメントの宣言-->
<footer th:fragment="copy"></footer>

<!--Insert：Divで囲う-->
<div th:insert="footer :: copy"></div>
<div>
    <footer></footer>
</div>

<!--Replace：置き換え-->
<div th:replace="footer :: copy"></div>
<footer></footer>

<!--Include-->
<div th:include="footer :: copy"></div>
<div></div>
```

# Spring Initializer 導入
1. Dependencyの追加
```gradle
Spring Initializerより生成してコピペ
implementation 'org.springframework.boot:spring-boot-starter-security'
testImplementation 'org.springframework.security:spring-security-test'
```
2. サーバーを再起動させて動作確認
ターミナル上に以下のようなログイン用のパスワードが生成されます。（コピペしておく）
```terminal
Using generated security password: 34fa3455-6c53-9374-8a7a-35e8a6c91eec
```
ローカルホストよりアクセスすると今までアクセスできていたページに認証が必要となっているので認証情報を入力  
username: user, password: (copy&paste)

# Sessionの管理について
* セッションIDは推測されにくい形の物を発行する
* セッションIDは固定化しないようにログイン時などには再発行するようにする
