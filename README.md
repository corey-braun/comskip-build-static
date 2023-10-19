# comskip-build-static
Docker image that builds [comskip](https://github.com/erikkaashoek/Comskip) as a statically-linked binary. The binary can then be run on the host machine, or in another container via a [bind mount](https://docs.docker.com/storage/bind-mounts/).

When run, the image first builds the ffmpeg libraries, then uses those libraries to build comskip.

## Usage
For easy usage, the included `build-comskip.sh` script can be run to build the image and run the container with a single command. This script will start the container in the background, where it will likely take around 20 minutes to finish building comskip. After the container has finished running, the comskip binary will be output at `./bin/comskip` and the container will be auto-removed.

If you want to watch the container's logs as it builds comskip, you can run `docker logs -f comskip-build-static`.

To reduce the comskip binary's size after it is built, you can run `strip bin/comskip` to strip non-essential debug symbols. When building comskip from the most recent version at the time of writing (commit `6e66de5` from 1/23/2023), stripping the binary brought its size down from 83MiB to 18MiB.

### Advanced Usage
For more advanced usage, you can edit `build-comskip.sh`, or build and run the image manually.

When running the image, a local volume should be bind mounted to `/build/bin` inside the container, as this is the directory in which the comskip binary is output.

Using container environment variables (which are easily editable in `build-comskip.sh`), you can specify different versions of [ffmpeg](https://ffmpeg.org/releases/) (default `FFMPEG_VERSION=5.0.1`) or [comskip](https://github.com/erikkaashoek/Comskip/commits/) (default `COMSKIP_VERSION=master`) to build. When setting `COMSKIP_VERSION`, valid values are any version of [erikkaashoek/Comskip](https://github.com/erikkaashoek/Comskip), including:
- A branch, such as `master`
- A release tag, such as `0.82.009`
- A commit ID, such as `6e66de5`

At the time of writing, the most recent comskip version (commit `6e66de5` from 1/23/2023) supports a maximum ffmpeg version of 5.0.1, which is thus the default for this image. With future comskip commits, specifying a newer ffmpeg version may be required to build comskip from branch "master".
