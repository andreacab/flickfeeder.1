class Dashboard extends React.Component {
  render () {
    return (
      <div>
        <div>Title: {this.props.title}</div>
      </div>
    );
  }
}

Dashboard.propTypes = {
  title: React.PropTypes.string
};
