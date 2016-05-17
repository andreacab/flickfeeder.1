class Dashboard extends React.Component {
  render () {
    return (
      <div>
        <div>Title: {this.props.title}</div>
        {this.props.thumbnails.map(thumb => {
            return <img style={Imgstyle} src={thumb.link} />
        })}
      </div>
    );
  }
}

Dashboard.propTypes = {
  title: React.PropTypes.string,
  thumbnails: React.PropTypes.array
};

let Imgstyle = {
    width: '20%',
    height: 'auto'
}