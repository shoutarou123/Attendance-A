import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="edit-overtime-req"
export default class extends Controller {
  // フォームが送信されたときに呼ばれるメソッド
  submit(event) {
    // フラッシュメッセージ領域をクリアする
    const flashContainer = document.getElementById('flash');
    if (flashContainer) {
      flashContainer.innerHTML = '';
      flashContainer.className = '';
    }

    // フォーム送信後の処理（例: モーダルを閉じる）
    this.close();
  }


  // モーダルを閉じるメソッド
  close() {
    this.element.remove(); // モーダルの要素を削除
  }
}

// モーダルをリロードするためのメソッド　これがないとメッセージ表示されない
document.addEventListener("turbo:frame-missing", (event) => {
      const { detail: { response, visit } } = event;
      event.preventDefault();
      visit(response.url);
});