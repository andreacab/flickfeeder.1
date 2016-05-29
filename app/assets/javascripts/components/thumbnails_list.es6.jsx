class ThumbnailsList extends React.Component {
    render () {
        return (
            <div id={'medias_list'}>
                {(!this.props.thumbnails || this.props.thumbnails.length <= 0 ) ? 
                    <p>{'No Thumbnails found...'}</p> : null}
                {this.props.thumbnails.map((thumbSrc, ind) => {
                    return <img key={ind} style={Imgstyle} src={thumbSrc} />;
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
