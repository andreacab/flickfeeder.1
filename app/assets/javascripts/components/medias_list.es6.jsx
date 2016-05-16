
class MediasList extends React.Component {
  render () {
    return (
      <div>
        {!this.props.medias ? <p>{'No medias added...'}</p> : null}
        {this.props.medias.map(media => {
            return <img src="" />
        })}
      </div>
    );
  }
}

MediasList.propTypes = {
  medias: React.PropTypes.array
};
