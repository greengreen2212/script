#sync rom
repo init --depth=1 --no-repo-verify -u https://github.com/crdroidandroid/android -b 12.1 -g default,-mips,-darwin,-notdefault
git clone https://github.com/walternewtz/local_manifest.git --depth 1 -b crdroid12.1 .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j10

#build 
source build/envsetup.sh
lunch lineage_beryllium-user
export TZ=Asia/Delhi
export BUILD_USERNAME=beryllium
export BUILD_HOSTNAME=user
export SKIP_ABI_CHECKS=true
export SKIP_BOOTJAR_CHECKS=true

#
#mka api-stubs-docs #& mka module-lib-api-stubs-docs #& mka system-api-stubs-docs #& mka test-api-stubs-docs
make bacon #&
#sleep 65m
#kill %1

until [ $? == 0 ] ;
do
   sleep 10
   make bacon
done 

#trying to fix oom container error
#until [ -f /$WORKDIR/rom/$name_rom/out/target/product/beryllium/*.zip ] ;
#do
     # make bacon -j30
    #  sleep 10
     # echo ROM building complete
#done
      #echo move to other task


# upload rom
rclone copy out/target/product/$(grep unch $CIRRUS_WORKING_DIR/build.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)/*.zip cirrus:$(grep unch $CIRRUS_WORKING_DIR/build.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1) -P
