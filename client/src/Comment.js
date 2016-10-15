import React from 'react';
import {Panel} from 'react-bootstrap'

var Comment = React.createClass({
  render: function() {
    return (
      <div>
        <Panel header={this.props.author}>
          {this.props.children}
        </Panel>
      </div>
    );
  }
});

export default Comment;
