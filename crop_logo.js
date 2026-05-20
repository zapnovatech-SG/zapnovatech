const Jimp = require('jimp');

async function cropImage() {
    const image = await Jimp.read('sanko_logo_final.png');
    image.autocrop().write('sanko_logo_cropped.png');
    console.log('Image cropped and saved as sanko_logo_cropped.png');
}

cropImage().catch(err => console.error(err));
