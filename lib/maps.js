function getMaps(){
    require([
        "esri/config",
        "esri/Map",
        "esri/views/SceneView"
    ],(esriConfig, Map, SceneView)=> {
    esriConfig.apiKey = "YOUR_API_KEY";

    const map = new Map({
        basemap: "arcgis-imagery", //Basemap layer service
        ground: "world-elevation" //Elevation service
    });

    const view = new SceneView({
        map: map,
        camera: {
        position: {
            x: -118.808, //Longitude
            y: 33.961, //Latitude
            z: 2000 // Meters
        },
        tilt: 75
        }
    });
    })
};
