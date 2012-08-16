# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120816063424) do

  create_table "repos", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "owner"
    t.datetime "github_created_at"
    t.datetime "github_updated_at"
    t.string   "description"
    t.string   "homepage"
    t.string   "language"
    t.integer  "forks"
    t.integer  "stars"
    t.integer  "issues"
    t.integer  "todos"
    t.string   "git_url"
  end

  add_index "repos", ["description"], :name => "index_repos_on_description"
  add_index "repos", ["forks"], :name => "index_repos_on_forks"
  add_index "repos", ["github_created_at"], :name => "index_repos_on_github_created_at"
  add_index "repos", ["github_updated_at"], :name => "index_repos_on_github_updated_at"
  add_index "repos", ["homepage"], :name => "index_repos_on_homepage"
  add_index "repos", ["issues"], :name => "index_repos_on_issues"
  add_index "repos", ["language"], :name => "index_repos_on_language"
  add_index "repos", ["name"], :name => "index_repos_on_name"
  add_index "repos", ["owner"], :name => "index_repos_on_owner"
  add_index "repos", ["stars"], :name => "index_repos_on_stars"
  add_index "repos", ["todos"], :name => "index_repos_on_todos"

  create_table "todo_files", :force => true do |t|
    t.integer  "repo_id"
    t.string   "sha"
    t.string   "path"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.text     "content"
  end

  add_index "todo_files", ["repo_id"], :name => "index_todo_files_on_repo_id"
  add_index "todo_files", ["sha"], :name => "index_todo_files_on_sha"

  create_table "todo_lines", :force => true do |t|
    t.integer  "todo_file_id"
    t.integer  "line_num"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "todo_lines", ["todo_file_id"], :name => "index_todo_lines_on_todo_file_id"

end
