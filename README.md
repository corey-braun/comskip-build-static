# comskip-build-static
Docker image that builds [comskip](https://github.com/erikkaashoek/Comskip) as a statically-linked binary.

The image first builds ffmpeg, then uses the ffmpeg libraries to build comskip.

For convenience, the included `build-comskip.sh` script can be used to build the image and run the container with a single command, outputting the comskip binary at `./bin/comskip` and auto-removing the container when finished.

## Usage
After building the image, it should be run with a local volume bind mounted to `/build/bin` in the container. When the container is finished running the comskip binary will be output in this volume.

You can specify a different ffmpeg version or comskip tar download link using environment variables `FFMPEG_VERSION` (default "4.3.6") and `COMSKIP_TAR_DL` (default "https://github.com/erikkaashoek/Comskip/archive/master.tar.gz"). Changing these variables may be required if future comskip updates need a newer ffmpeg version.

After starting the container, you can follow its progress by attaching to the container's logs using `docker logs -f <container>`. The container should take around 15 minutes to finish building comskip.

Once the comskip binary is built, you can reduce its file size by stripping symbols using `strip <comskip binary>`. At the time of writing this takes the size of the binary down from 82MiB to 18MiB.
