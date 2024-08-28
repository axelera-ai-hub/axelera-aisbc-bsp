# voyager-yocto-setup

`voyager-yocto-setup` is Axelera openembedded distro for support AI accelerator

# What's inside?

This repository is composed of:

 * `.config.yaml`: a kas configuration file
 * `meta-axelera`: the layer with the (fictitious) metadata for the products
   of a (fictitious) company

The `.config.yaml` is the configuration file for the
[kas](https://kas.readthedocs.io/) utility, which allows to easily download
all the required third-party components in the correct place and enable
them in the configuration. In this example it downloads and enables:

 * the `bitbake` build engine
 * the `openembedded-core` repository which contains the `meta` layer
   with all the "core" recipes
 * the `meta-arm` repository which contains the `meta-arm` and
   `meta-arm-toolchain` layers
 * the `meta-axelera` layer, not downloaded as it is already part of this
   repository, but enabled in `build/conf/bblayers.conf`

Using kas is not mandatory to use Yocto/OpenEmbedded, but we found it
simple and convenient. You can use another tool for your project if so you
prefer.

# The `meta-axelera` layer

`meta-axelera` is a layer that will support specific Axelera components

The `meta-axelera` layer provides:

 * support for firefly-rk3588
 * a distro configuration
 * a few recipes, including kernel, U-Boot, a userspace application and an
   image recipe

## Machines

The meta-axelera layer contains fireflyx machine configurations, called
**firefly-rk3588**.

# Run your first build

kas-container build

# Build the host sdk

kas-container shell .config.yaml -c "bitbake -fc populate\_sdk voyager-image"
