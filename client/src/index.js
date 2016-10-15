import React from 'react';
import ReactDOM from 'react-dom';
import CommentBox from './CommentBox';
import './index.css'

ReactDOM.render(
  <CommentBox url="/api/comments" pollInterval={10000} />,
  document.getElementById('root')
);
