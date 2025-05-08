'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".git/COMMIT_EDITMSG": "9c8aa32c6a5a7be01f0993893e6ea965",
".git/config": "14ad64d6989cd516f5e2a88f46e9c3f8",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/HEAD": "5ab7a4355e4c959b0c5c008f202f51ec",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-commit.sample": "5029bfab85b1c39281aa9697379ea444",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/hooks/sendemail-validate.sample": "4d67df3a8d5c98cb8565c07e42be0b04",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/index": "9ec8910aebeeeea4ee9e3245c148429b",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "ac4226a31b2f7a72678938c889bcbe44",
".git/logs/refs/heads/gh-pages": "ac4226a31b2f7a72678938c889bcbe44",
".git/logs/refs/remotes/origin/gh-pages": "a3ace660f1c7fcb0d8dab06b13471471",
".git/objects/06/5a156ad876ae75d08bca0aabc8c1e01f285abb": "1338ac20d12542d14345378e2fe2be26",
".git/objects/1c/27f1c2d8303b86ce37c52613f9ef96d0cb0dad": "77050b912813a8f7cc7ddd7391170ddd",
".git/objects/1c/5f7a46adc84a60ec7380adf3de8184922e0125": "5877c1789f89a9819ab26553f3e4b28d",
".git/objects/1d/468b85698a60041b450286f31b3264b3bbd6f7": "5c8c497111befde32ac151f14cf92f85",
".git/objects/20/ed9ba02811fd83896832449cb8ad685e0c638b": "819ba2bdecfce71a90df5608a34e39a1",
".git/objects/23/e04fcfba7eef3a95ed1ad6a5e969e536c6768f": "863fef24b90d30d85aa911fe5694c4f2",
".git/objects/2d/0471ef9f12c9641643e7de6ebf25c440812b41": "d92fd35a211d5e9c566342a07818e99e",
".git/objects/35/96d08a5b8c249a9ff1eb36682aee2a23e61bac": "e931dda039902c600d4ba7d954ff090f",
".git/objects/39/31ec16cd6b7e5af871f3864d2c0722400bbe26": "319a8b5d4ee02d9574277638fb2627a6",
".git/objects/39/c63d7461796094c0b8889ee8fe2706d344a99a": "48256a6331250da587409326c8e4d957",
".git/objects/3b/b0860a0981211a1ab11fced3e6dad7e9bc1834": "3f00fdcdb1bb283f5ce8fd548f00af7b",
".git/objects/3f/eb72cba45f17ec26a9b61afaa9cce84e0a896b": "e04a15a5d82602c2c6cd74908016f2f8",
".git/objects/40/1184f2840fcfb39ffde5f2f82fe5957c37d6fa": "1ea653b99fd29cd15fcc068857a1dbb2",
".git/objects/43/1af34d48eb729e5362616f67b81c1213229411": "8a8e826104c1c9dcb709d06a2b5044df",
".git/objects/46/f2875bdb45b3c113504daca2311edf194ea5eb": "c4c05b1c54d6948981639400f0033896",
".git/objects/4f/a622684ee5b1de6752964fa38929e16a9009a6": "fc8d2ea6786ba7b83849630385783638",
".git/objects/53/3402c75429e6feaa7b8f92878ae2313dbdf2de": "63ab067b0b447b461fa3e8f58a1f23a9",
".git/objects/57/7946daf6467a3f0a883583abfb8f1e57c86b54": "846aff8094feabe0db132052fd10f62a",
".git/objects/5f/bf1f5ee49ba64ffa8e24e19c0231e22add1631": "f19d414bb2afb15ab9eb762fd11311d6",
".git/objects/66/b29f97517150c0c9d290fd8073d8448d81665b": "b2d431198f3b8d09c367fa309125c731",
".git/objects/68/ce6c04b87965a6e75bd710b7fdef5393922a68": "c4853d412a2d1b878f3b811dc4cd4dd8",
".git/objects/6b/9862a1351012dc0f337c9ee5067ed3dbfbb439": "85896cd5fba127825eb58df13dfac82b",
".git/objects/6d/479afaf6dcab449f2408da1058fc92c6387710": "ed654388d094e4110dbc50dbb4391668",
".git/objects/72/3d030bc89a4250e63d16b082affe1998618c3f": "e4299c419434fc51f64a5266659918fa",
".git/objects/74/1bcf99ba3738b9143a769b064114a0e6f924ad": "7ec01842f969e3f3f0e4cb9c076db4f6",
".git/objects/80/3c276ed8b58cb5fb4b8bf08c279be3b7a2c98d": "d9fca3a64b969d669837b7d0fa681c3d",
".git/objects/84/34b4bc4ba61059dfb067adf026a390c6991254": "43bc07dd96a35fcfcd2870dacb96ef56",
".git/objects/88/a54fcb6806ac7f3fbfb02e342cc96b162822cd": "2254fd66ba867eb4e3e637d40ca1ddb6",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/8a/51a9b155d31c44b148d7e287fc2872e0cafd42": "9f785032380d7569e69b3d17172f64e8",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/8a/cda3b814f71435954016af9b350026b54b4f32": "3fba918ee010ad68f1d14a84d1515a29",
".git/objects/8c/082c8de090865264d37594e396c4d6c0099fe4": "5117224fcb2873172ee6cba59c00a7ee",
".git/objects/8d/a073241c2bdc0665bf50037838262c5b92af70": "13cb2b459fa97a4608cc0e7554bd2dce",
".git/objects/8e/e4886a67ac5b47b1298f04965d981e20fc60d7": "ef463cb33a523e1e910df353f1c41296",
".git/objects/8f/c8be62f202c40e7d3e2e16242fb065cfc4e1a7": "6fda1b80da67a8d96186cf8ab8b24087",
".git/objects/91/4a40ccb508c126fa995820d01ea15c69bb95f7": "8963a99a625c47f6cd41ba314ebd2488",
".git/objects/9f/475d2b70a9a110d5ba2f0d86a206d51bda45b5": "278c1cd801e547a08b8bb012c0e413eb",
".git/objects/a3/55c27cde02b13da43c30ae060c5fb164b36b76": "e0bf2d141d04df7a9a41463523408d29",
".git/objects/a5/de584f4d25ef8aace1c5a0c190c3b31639895b": "9fbbb0db1824af504c56e5d959e1cdff",
".git/objects/a6/8edcf443fec6c5685e020f642080b6515dc5bd": "776590f1d1d0ddc2f815bb57ee037f4a",
".git/objects/a7/d498188f651ef2e246e41f580dab1686c226a9": "095c8e8bd11b4f18fb841e0cc7a2adb9",
".git/objects/a8/8c9340e408fca6e68e2d6cd8363dccc2bd8642": "11e9d76ebfeb0c92c8dff256819c0796",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/be/4c98946fdb82b70d394a55869a33644f96e5bd": "f7415339f3d5642fa749f2428a3816bc",
".git/objects/c2/aa36aede1041824ca434861e8a3aef97252e40": "41b1cefeea1bc122ed151f69eda0af0d",
".git/objects/c6/1828294bf8eb22b226b8db299d88952bf07e9f": "fee8c10758e19821dbde0a287b4d344e",
".git/objects/c7/7663172ca915a99a594ca17d06f527db05657d": "6335b074b18eb4ebe51f3a2c609a6ecc",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/d5/f5845286c38099759ea32a6857411818c0792f": "5abf8d0535605f2cf11a9d61c925e4a3",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/d8/09c9509be4bc7a93e0a18c57257b67a6150eef": "1c08b11a46b189a7934c1493df3c78b3",
".git/objects/d9/3952e90f26e65356f31c60fc394efb26313167": "1401847c6f090e48e83740a00be1c303",
".git/objects/e6/d9a5f5f5f4233af695bae70ce515b6344e73ac": "139fc30ef2353539f7c663e2ea653be0",
".git/objects/e8/10a97e0ed02f2dd20cdd3e72f4107ceb93d4ff": "5f3e2293356e255dff409b947291812f",
".git/objects/e9/94225c71c957162e2dcc06abe8295e482f93a2": "2eed33506ed70a5848a0b06f5b754f2c",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/ee/8b72f51015219cecd5478a024d9511be2fc18d": "25d1fb7a0403804df9cd7dac17f434c5",
".git/objects/ef/b875788e4094f6091d9caa43e35c77640aaf21": "27e32738aea45acd66b98d36fc9fc9e0",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/f3/709a83aedf1f03d6e04459831b12355a9b9ef1": "538d2edfa707ca92ed0b867d6c3903d1",
".git/objects/f5/05a707c33eaac7ce69e1c762dc4c83b92d94b4": "e023bf378cf8f5c21c7f7ed35a631915",
".git/objects/f5/72b90ef57ee79b82dd846c6871359a7cb10404": "e68f5265f0bb82d792ff536dcb99d803",
".git/objects/fa/38961487ba7a0a3310209b0446497d599d892b": "c7674ce08fe3292e6619c08bba35fa43",
".git/objects/fa/fc3a740647650a9abb595a894e4d02b7356316": "104f8ac4dbddbb3a3d9ac3b0ece33a40",
".git/refs/heads/gh-pages": "72ef709b613923904c19897f27e2a8b6",
".git/refs/remotes/origin/gh-pages": "72ef709b613923904c19897f27e2a8b6",
"assets/AssetManifest.bin": "43838677b8f8377078a6b123c8e2203c",
"assets/AssetManifest.bin.json": "eda4695d01bbeaee84403657035020e3",
"assets/AssetManifest.json": "bd3938298554ab9eceaaf053c1209d13",
"assets/assets/fonts/Roboto-Bold.ttf": "d329cc8b34667f114a95422aaad1b063",
"assets/assets/fonts/Roboto-Medium.ttf": "fe13e4170719c2fc586501e777bde143",
"assets/assets/fonts/Roboto-Regular.ttf": "ac3f799d5bbaf5196fab15ab8de8431c",
"assets/assets/icons/back_icon.png": "34fbf9de1a3ad93fc0c5a922ac3f6f04",
"assets/assets/icons/camera_image.png": "24af36702a34b8f1b114b3609e4183e0",
"assets/assets/icons/dashboard_logo.png": "3ec20e82068219184475b65e69f0bc27",
"assets/assets/icons/gallery_image.png": "a4ef1745b950b6feeef63250a7521ae1",
"assets/assets/icons/logo.png": "df9b616085ee77d2ad0a911f0b58381d",
"assets/assets/icons/logo_white.png": "644ef998dd5d8e8b6165ffbac38065b7",
"assets/assets/images/login_image.png": "a8d280407f1bd5c30d5f107370779c3e",
"assets/assets/images/splash_bg.png": "ab0d3c0b7ac37de53b0b5bf0aa138bc5",
"assets/FontManifest.json": "a17d9f53ca2b3ae7ca92afa8598d2111",
"assets/fonts/MaterialIcons-Regular.otf": "0560c9c146e244e8d9f9914545dc2d6b",
"assets/NOTICES": "87817e1c66fce36a1d1fc1d6e1958828",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
"assets/packages/lucide_icons/assets/lucide.ttf": "f9ba0b4172a0beabfecd5857b55dfe72",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "6cfe36b4647fbfa15683e09e7dd366bc",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/chromium/canvaskit.js": "ba4a8ae1a65ff3ad81c6818fd47e348b",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"flutter_bootstrap.js": "02ade82eaca07dcebe35013d7267079e",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "2b8fee1303fda975c6414cd1dc3c0b70",
"/": "2b8fee1303fda975c6414cd1dc3c0b70",
"main.dart.js": "43912efc24a2a351ca9e549558aa450f",
"manifest.json": "ce6fa1ea2ceb825a2800ad3b4f40ff57",
"version.json": "37308edc9e1861cdedfbe54d9917ba1b"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
