// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
//= require bootstrap
//= require popper
import { createApp } from '../../node_modules/vue/dist/vue.esm-bundler';
  
const app = createApp({  
  data() {  
    return {  
      course: 'Intro to Vue 3 and Rails'
    }  
  }  
})  
  
app.mount('#app'); 