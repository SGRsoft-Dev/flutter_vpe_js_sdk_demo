# VPE Javascript SDK for Flutter

### 플러터에서 VPE Javascript SDK를 적용한 예제 파일입니다.

<img src="https://nnbkegvqsbcu5297614.cdn.ntruss.com/profile/202311/4fb35b3571c3aab85482e98f8b2c8be3.png" style="max-width:300px">

***


### 웹뷰 설정 (lib/videoView.dart) 

```dart

...

 controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel("vpeToApp", onMessageReceived: (JavaScriptMessage message){
            //전체 화면 제어 Webview => Flutter
            if(message.message == "fullscreenOn"){
              SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
            }else if (message.message == "fullscreenOff"){
              SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
            }

      })
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {},
          onPageStarted: (url) {},
          onPageFinished: (url) {
            String message = "flutterRun";
            controller.runJavaScript('appToWeb("$message")');
          },
          onWebResourceError: (error) {},
          onNavigationRequest: (request) {
            if (request.url.startsWith('url')) {
              return NavigationDecision.prevent;
            } else {
              return NavigationDecision.navigate;
            }
          },
        ),
      )
      //VPE 웹뷰 페이지
      //..loadFlutterAsset('assets/index.html');
      ..loadRequest(Uri.parse('https://mediaplus-demo.web.app/fl/player.html'));


...

```



### VPE Javascript SDK 적용 (assets/index.html)

> ⚠️ Naver Cloud Platform VPE 1.1.2 버전 이상을 사용해야 합니다. (12월 배포 예정)<br>
> 예제는 1.1.2 beta 버전을 사용하였습니다.<br>
> VPE 유료 라이선스가 필요합니다.

```html

<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0">
	<title>Title</title>
	<script src="https://player.vpe.naverncp.com/ncplayer.1.1.2.js?access_key=17e49e099ea78c1f1ae159fc1647316c&v=3"></script>


	<style>
        *,
        *::before,
        *::after {
            box-sizing: border-box;
        }

        * {-webkit-tap-highlight-color:transparent;}
        body{
            padding:0;
            margin:0;
            background-color:#000;
            overflow:hidden;
        }
        .playerWarp {
            width: 100vw;
            height: 100vh;
            background-color: #000;
            color:#fff;
        }

        #playerBasic,
        .vpe-player-root-frame {
            width: 100vw;
            height: 100vh;

        }

        @media (orientation: portrait) {

            .vpe-player-root-frame .ncp_player_root{
                padding-top: calc(env(safe-area-inset-top) + 80px);
            }

            .vpe-player-root-frame .control_bar > .pos_a {
                padding-bottom: calc(env(safe-area-inset-bottom) + 65px);
            }
        }

        @media (orientation: landscape) {
            #playerBasic,
            .vpe-player-root-frame {
                width:calc(100vw - (env(safe-area-inset-left) + env(safe-area-inset-right) + 5px) );

                padding-left: calc(env(safe-area-inset-left) + 10px);
                padding-right: calc(env(safe-area-inset-right) + 10px);
            }

            .vpe-player-root-frame .control_bar > .pos_a {
                padding-bottom: calc(env(safe-area-inset-bottom) + 15px);
            }
        }
	</style>

</head>
<body>

<div class="playerWarp">
	<div id="playerBasic"></div>
</div>


<script>
	let player = null;
	let setupTimer = null;
	let isFlutterApp = false;

	/**
	 * vpe to flutterApp postMessage
	 * @param msg
	 */
	const appToWeb = (msg)=>{
		try {

			vpeToApp.postMessage(msg);
			isFlutterApp = true;
		}catch(e){

		}
	}



	setupTimer = setInterval(() => {
		appToWeb(location.href);
		try {
			player = new ncplayer("playerBasic", {
				playlist: [
					{
						file: "https://fsxikvammvwv14470411.cdn.ntruss.com/hls/9N5-iJ4f9tdzE6D708PTmg__/vod/j5IXBfIJ83893893_,1080,720,480,p.mp4.smil/master.m3u8",
						poster: "https://wnfosehmzhuc12665447.cdn.ntruss.com/thumb/sample_thumb.png?type=m&w=1024&h=760&ttype=jpg",
						description: {
							title: "네이버클라우드 소개 영상",
							created_at: "2023.07.13",
							profile_name: "네이버클라우드",
							profile_image:
								"https://nnbkegvqsbcu5297614.cdn.ntruss.com/profile/202208/d127c8db642716d84b3201f1d152e52a.png",
						},
					},
				],
				autostart: true,

				controlBtn: {
					play: true,
					fullscreen: true,
					volume: true,
					times: true,
					pictureInPicture: true,
					setting: false,
					subtitle: false,
				},
				progressBarColor: "#ff0000",
				aspectRatio: "16/9",
				objectFit: "contain",
				autoPause: false,
				repeat: false,

				override:{ //전체화면 기능 오버라이드
					fullscreen:{
						on:()=>{
							try {
								vpeToApp.postMessage('fullscreenOn');
							}catch(e){

							}
						},
						off:()=>{
							try {
								vpeToApp.postMessage('fullscreenOff');
							}catch(e){

							}
						}
					}
				}
			});
			clearInterval(setupTimer);
		} catch (e) {}
	}, 100);
</script>
</body>
</html>


```


### 미디어 보안 적용 (lib/secure_shot.dart)

dart = SecureShot <br>
ios = appdelegate <br>
aos = mainactivity 참조

