class ThumbnailsList extends React.Component {
    render () {
        return (
            <div>
                {( !this.props.thumbnails || this.props.thumbnails.length <= 0 ) ? 
                    <p>{'No Thumbnails found...'}</p> : null}
                {this.props.thumbnails.map(thumb => {
                    return <img style={Imgstyle} src={thumb.link} />
                })}
            </div>
        );
    }
}

ThumbnailsList.propTypes = {
    thumbnails: React.PropTypes.array
};

let Imgstyle = {
    width: '20%',
    height: 'auto'
};
