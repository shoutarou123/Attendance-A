Attendance A を ssh で接続
1/6 storage 内の development.sqlite3 を windows プロンプトで削除し vscode のターミナルで bin/rails db:setup を実施、データベースの user 情報が全て無くなったことから、rails db:migrate を実施し、その後 rails アプリ上で新規登録した。

index.html.erb の<%= link_to user.name, user %>は使用しないため避難。

以下 index.html.erb の全コード避難。
<% provide(:title, 'All Users') %>

<h1>ユーザー一覧</h1>

<div class="col-md-10 col-md-offset-1">
  <%= paginate @users, theme: 'twitter-bootstrap-4' %> <!--will pegenateからkaminariに変更-->
  <table class="table table-condensed table-hover" id="table-users">
    <thead>
      <tr>
        <th><%= User.human_attribute_name :name %></th> <!--名前-->
      </tr>
    </thead>

    <% @users.each do |user| %>
      <tr>
        <td>
          <%= user.name %> <!--名前表示 勤怠画面に遷移-->
        <td class="center">
            <% if current_user.admin? && !current_user?(user) %> <!--!current_user?(user)は、現在のﾕｰｻﾞｰが表示されているﾍﾟｰｼﾞのﾕｰｻﾞｰ以外であること。!がないと管理者だけ削除ﾎﾞﾀﾝが表示されてしまう-->
            <%= link_to "削除", user, data: { turbo_method: :delete, turbo_confirm: "削除してよろしいですか？" }, class: "btn btn-danger" %>
            <% end %>
          </td>
        </td>
      </tr>
    <% end %>

  </table>
  <%= paginate @users, theme: 'twitter-bootstrap-4' %>
</div>
