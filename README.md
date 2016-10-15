#React Tutorial with create-react-app and Rails as an Api and Bootstrap

Man, that title is a mouthful, but, this is pretty easy. Once again, we're focussing on the [React tutorial](https://facebook.github.io/react/docs/tutorial.html). Since it's a great intro to React.

First, ensure you have the Create React App installed globally:

```text
npm i -g create-react-app
```
Now let's create a rails api for the backend, please be sure to have Rails 5. 

```text
rails new react_tutorial_with_rails_api --api
cd react_tutorial_with_rails_api
```

you can initialize your git now if you'd like :)

Now we're going to create the react app in the rails app directory, we'll call it client:

```text
create-react-app client
```

What just happened? The amazing team at React HQ made it as simple as creating a Rails app, to create a React App. Thanks guys! Now all your web pack config is set up for a basic app. this is all we need to get started.

If you initialized your git, it would be a good idea to add to your rails .gitignore file:

```text
client/node_modules
```

Otherwise your git will become unruly. 

Ok, now lets set up Rails to be the back end. We need to add a model. 

We'll call the model Comment and we'll create 2 columns, author which will be a string, and text which we'll make text. This way we're in line with the naming conventions of the React Tutorial:

```text
rails generate model comment author:string text:text
rails db:migrate
```

A slight aside here, the React Tutorial uses the date to be a unique identifier, which is too ling for rails standard id's, so we're going to make a slight edit to the id column of the Comments table:

```text
rails generate migration change_comments_id_integer_limit
```

Now we add the following:

```ruby
# db/migrate/*change_comments_id_integer_limit.rb
class ChangeCommentsIdIntegerLimit < ActiveRecord::Migration[5.0]
  def change
    change_column :comments, :id, :integer, limit: 8
  end
end
```

```text
rails db:migrate
```

Ok, nearly done here, we just need a controller and the routes.

The controller needs 2 actions, index and create:

```text
rails generate controller comments index create
```

And, I'll spare the walk through, but here is what the final controller should look like:

```ruby
# app/controller/comments_controller.rb
class CommentsController < ApplicationController
  def index
    render(
      status: 200,
      json: Comment.all
    )
  end

  def create
    comment = Comment.new(comment_params)
    if comment.save
      render json: comment, status: 201
    else
      render json: { errors: comment.errors }, status: 422
    end
  end

  private
  
  def comment_params
    params.permit(:id, :author, :text)
  end

end
```

Now, let's hook up the routes:

```ruby
# config/routes.rb
Rails.application.routes.draw do
  scope '/api' do
    get :comments, to: 'comments#index'
    post :comments, to: 'comments#create'
  end
end
```

We'll now create a rake task to spin up both React Server and Rails server simultaneously. A lot of steps here, but it's all to prevent something called [Cross-origin resource sharing.](https://en.wikipedia.org/wiki/Cross-origin_resource_sharing)

```text
echo "gem 'foreman'" >> Gemfile
bundle install
touch Procfile
echo "web: cd client && npm start" >> Procfile
echo "api: bundle exec rails s -p 3001" >> Procfile
touch lib/tasks/start.rake
```

```ruby
# lib/tasks.start.rake
task :start do
  exec 'foreman start -p 3000'
end
```

Oh, now for the React part. There will be just copy and pasting of the code, since the [tutorial](https://facebook.github.io/react/docs/tutorial.html) walks you through it pretty succinctly. 

```text
cd client
```

Now, we install jQuery and Bootstrap for React:

```text
npm install jquery --save
npm install react-bootstrap --save
```

Add the following to your head tag in public index:

```html
<!-- client/public/index.html -->
<head>
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/latest/css/bootstrap.min.css">
</head>
```

And body can look like this for bootstrap:

```html
<!-- client/public/index.html -->
 <body>
    <div class="container">
      <div id="root"></div>
    </div>
  </body>
```

Now in your client/package.json file, add the following line under:
"private": true

```json
"proxy": "http://localhost:3001/"
```

The final piece is to just copy the following files from [github](https://github.com/tobyond/react_tutorial_with_rails_api):

client/src/Comment.js
client/src/CommentBox.js
client/src/CommentForm.js
client/src/CommentList.js
client/src.index.js

Now, from the react_tutorial_with_rails_api directory you can run:

```text
rake start
```

And the app should work. Complete with bootstrap styling, and jQuery polling.


