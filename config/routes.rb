RedmineApp::Application.routes.draw do
  
  match 'batch/allocation' => 'batch#allocation', :via => :get
  
end
