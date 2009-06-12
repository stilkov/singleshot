# Singleshot  Copyright (C) 2008-2009  Intalio, Inc
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


ActionController::Routing::Routes.draw do |map|

  map.resources 'tasks', :collection=>{ 'completed'=>:get, 'following'=>:get, 'complete_redirect'=>:get },
    :member=>['activities'] do |tasks|
    tasks.with_options :controller=>'task_for' do |opts|
      opts.connect 'for/:person_id', :action=>'update', :conditions=>{ :method=>:put }
      opts.for_person 'for/:person_id', :action=>'show'
    end
  end
  map.connect '/tasks/:id', :controller=>'tasks', :action=>'update', :conditions=>{ :method=>:post }

  map.search '/search', :controller=>'tasks', :action=>'search'
  map.open_search '/search/osd', :controller=>'tasks', :action=>'opensearch'

  map.resources 'forms'
  map.resources 'templates'
  map.resources 'notifications'
  map.resources 'activities'
  map.resource  'graphs'
  map.resource 'session'
  map.resources 'password_resets'
  
  map.root :controller=>'tasks', :action=>'index'

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
#== Route Map
# Generated on 11 Jun 2009 22:44
#
#         completed_tasks GET    /tasks/completed(.:format)         {:controller=>"tasks", :action=>"completed"}
# complete_redirect_tasks GET    /tasks/complete_redirect(.:format) {:controller=>"tasks", :action=>"complete_redirect"}
#         following_tasks GET    /tasks/following(.:format)         {:controller=>"tasks", :action=>"following"}
#                   tasks GET    /tasks(.:format)                   {:controller=>"tasks", :action=>"index"}
#                         POST   /tasks(.:format)                   {:controller=>"tasks", :action=>"create"}
#                new_task GET    /tasks/new(.:format)               {:controller=>"tasks", :action=>"new"}
#         activities_task        /tasks/:id/activities(.:format)    {:controller=>"tasks", :action=>"activities"}
#               edit_task GET    /tasks/:id/edit(.:format)          {:controller=>"tasks", :action=>"edit"}
#                    task GET    /tasks/:id(.:format)               {:controller=>"tasks", :action=>"show"}
#                         PUT    /tasks/:id(.:format)               {:controller=>"tasks", :action=>"update"}
#                         DELETE /tasks/:id(.:format)               {:controller=>"tasks", :action=>"destroy"}
#                         PUT    /tasks/:task_id/for/:person_id     {:controller=>"task_for", :action=>"update"}
#         task_for_person        /tasks/:task_id/for/:person_id     {:controller=>"task_for", :action=>"show"}
#                         POST   /tasks/:id                         {:controller=>"tasks", :action=>"update"}
#                  search        /search                            {:controller=>"tasks", :action=>"search"}
#             open_search        /search/osd                        {:controller=>"tasks", :action=>"opensearch"}
#                   forms GET    /forms(.:format)                   {:controller=>"forms", :action=>"index"}
#                         POST   /forms(.:format)                   {:controller=>"forms", :action=>"create"}
#                new_form GET    /forms/new(.:format)               {:controller=>"forms", :action=>"new"}
#               edit_form GET    /forms/:id/edit(.:format)          {:controller=>"forms", :action=>"edit"}
#                    form GET    /forms/:id(.:format)               {:controller=>"forms", :action=>"show"}
#                         PUT    /forms/:id(.:format)               {:controller=>"forms", :action=>"update"}
#                         DELETE /forms/:id(.:format)               {:controller=>"forms", :action=>"destroy"}
#               templates GET    /templates(.:format)               {:controller=>"templates", :action=>"index"}
#                         POST   /templates(.:format)               {:controller=>"templates", :action=>"create"}
#            new_template GET    /templates/new(.:format)           {:controller=>"templates", :action=>"new"}
#           edit_template GET    /templates/:id/edit(.:format)      {:controller=>"templates", :action=>"edit"}
#                template GET    /templates/:id(.:format)           {:controller=>"templates", :action=>"show"}
#                         PUT    /templates/:id(.:format)           {:controller=>"templates", :action=>"update"}
#                         DELETE /templates/:id(.:format)           {:controller=>"templates", :action=>"destroy"}
#           notifications GET    /notifications(.:format)           {:controller=>"notifications", :action=>"index"}
#                         POST   /notifications(.:format)           {:controller=>"notifications", :action=>"create"}
#        new_notification GET    /notifications/new(.:format)       {:controller=>"notifications", :action=>"new"}
#       edit_notification GET    /notifications/:id/edit(.:format)  {:controller=>"notifications", :action=>"edit"}
#            notification GET    /notifications/:id(.:format)       {:controller=>"notifications", :action=>"show"}
#                         PUT    /notifications/:id(.:format)       {:controller=>"notifications", :action=>"update"}
#                         DELETE /notifications/:id(.:format)       {:controller=>"notifications", :action=>"destroy"}
#              activities GET    /activities(.:format)              {:controller=>"activities", :action=>"index"}
#                         POST   /activities(.:format)              {:controller=>"activities", :action=>"create"}
#            new_activity GET    /activities/new(.:format)          {:controller=>"activities", :action=>"new"}
#           edit_activity GET    /activities/:id/edit(.:format)     {:controller=>"activities", :action=>"edit"}
#                activity GET    /activities/:id(.:format)          {:controller=>"activities", :action=>"show"}
#                         PUT    /activities/:id(.:format)          {:controller=>"activities", :action=>"update"}
#                         DELETE /activities/:id(.:format)          {:controller=>"activities", :action=>"destroy"}
#              new_graphs GET    /graphs/new(.:format)              {:controller=>"graphs", :action=>"new"}
#             edit_graphs GET    /graphs/edit(.:format)             {:controller=>"graphs", :action=>"edit"}
#                  graphs GET    /graphs(.:format)                  {:controller=>"graphs", :action=>"show"}
#                         PUT    /graphs(.:format)                  {:controller=>"graphs", :action=>"update"}
#                         DELETE /graphs(.:format)                  {:controller=>"graphs", :action=>"destroy"}
#                         POST   /graphs(.:format)                  {:controller=>"graphs", :action=>"create"}
#         recover_session GET    /session/recover(.:format)         {:controller=>"sessions", :action=>"recover"}
#                         POST   /session/recover(.:format)         {:controller=>"sessions", :action=>"recover"}
#             new_session GET    /session/new(.:format)             {:controller=>"sessions", :action=>"new"}
#            edit_session GET    /session/edit(.:format)            {:controller=>"sessions", :action=>"edit"}
#                 session GET    /session(.:format)                 {:controller=>"sessions", :action=>"show"}
#                         PUT    /session(.:format)                 {:controller=>"sessions", :action=>"update"}
#                         DELETE /session(.:format)                 {:controller=>"sessions", :action=>"destroy"}
#                         POST   /session(.:format)                 {:controller=>"sessions", :action=>"create"}
#                    root        /                                  {:controller=>"tasks", :action=>"index"}
#                                /:controller/:action/:id           
#                                /:controller/:action/:id(.:format) 
