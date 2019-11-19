BUILD_DIRECTORY_NAME="RazerAuthSDK_Build"

rm -rf $BUILD_DIRECTORY_NAME

mkdir $BUILD_DIRECTORY_NAME

BUILD_DIRECTORY=./$BUILD_DIRECTORY_NAME

cd $BUILD_DIRECTORY

MKIT_SCHEME="RazerAUTHSDK"

rm -rf Output

mkdir Output

cd ..

xcodebuild -workspace RazerAUTHSDK.xcworkspace CODE_SIGNING_REQUIRED=NO BITCODE_GENERATION_MODE=bitcode OTHER_CFLAGS="-fembed-bitcode" ONLY_ACTIVE_ARCH=NO ENABLE_BITCODE=YES -scheme $MKIT_SCHEME -sdk iphoneos -configuration Release clean build -derivedDataPath $BUILD_DIRECTORY archive || exit 1

xcodebuild -workspace RazerAUTHSDK.xcworkspace CODE_SIGNING_REQUIRED=NO BITCODE_GENERATION_MODE=bitcode OTHER_CFLAGS="-fembed-bitcode" ONLY_ACTIVE_ARCH=NO ENABLE_BITCODE=YES -scheme $MKIT_SCHEME -sdk iphonesimulator -configuration Release clean build -derivedDataPath $BUILD_DIRECTORY || exit 1

cd $BUILD_DIRECTORY

cp -R Build/Products/Release-iphoneos/$MKIT_SCHEME.framework Output/

lipo -create -output Output/$MKIT_SCHEME.framework/$MKIT_SCHEME Build/Products/Release-iphoneos/$MKIT_SCHEME.framework/$MKIT_SCHEME Build/Products/Release-iphonesimulator/$MKIT_SCHEME.framework/$MKIT_SCHEME

cp -r Build/Products/Release-iphonesimulator/$MKIT_SCHEME.framework/Modules/$MKIT_SCHEME.swiftmodule/. Output/$MKIT_SCHEME.framework/Modules/$MKIT_SCHEME.swiftmodule/

echo "Build completed, now copy the file"

open Output

