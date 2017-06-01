Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0206.hostedemail.com ([216.40.44.206]:44467 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750726AbdFAECp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Jun 2017 00:02:45 -0400
Message-ID: <1496289760.2618.67.camel@perches.com> (sfid-20170601_060436_930250_CDEFCD7A)
Subject: Re: [RFC 3/3] MAINTAINERS: add maintainer entry for ks7010
From: Joe Perches <joe@perches.com>
To: Greg KH <greg@kroah.com>, "Tobin C. Harding" <me@tobin.cc>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-wireless@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        Tycho Andersen <tycho@tycho.ws>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Date: Wed, 31 May 2017 21:02:40 -0700
In-Reply-To: <20170601034630.GB7468@kroah.com>
References: <1496287628-16787-1-git-send-email-me@tobin.cc>
         <1496287628-16787-4-git-send-email-me@tobin.cc>
         <20170601034630.GB7468@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-06-01 at 12:46 +0900, Greg KH wrote:
> On Thu, Jun 01, 2017 at 01:27:08PM +1000, Tobin C. Harding wrote:
> > Add maintainers entry for ks7010.
[]
> > diff --git a/MAINTAINERS b/MAINTAINERS
[]
> > @@ -7429,6 +7429,13 @@ F:	Documentation/auxdisplay/ks0108
> >  F:	drivers/auxdisplay/ks0108.c
> >  F:	include/linux/ks0108.h
> >  
> > +KS7010 KEYSTREAM DRIVER
> > +M:      Tobin Harding <me@tobin.cc>
> > +L:      driverdev-devel@linuxdriverproject.org
> > +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
> > +S:      Maintained
> > +F:      drivers/staging/ks7010/
> 
> All tabs please :)

Right.  Perhaps someone could do:

$ sed -r -i -e "s/^([A-Z]):\s*/\1:\t/" MAINTAINERS

For today's -next, that gives:
---
 MAINTAINERS | 122 ++++++++++++++++++++++++++++++------------------------------
 1 file changed, 61 insertions(+), 61 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a4d082acb458..335a18e9785b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1080,7 +1080,7 @@ S:	Maintained
 F:	arch/arm/mach-meson/
 F:	arch/arm/boot/dts/meson*
 F:	arch/arm64/boot/dts/amlogic/
-F: 	drivers/pinctrl/meson/
+F:	drivers/pinctrl/meson/
 F:	drivers/mmc/host/meson*
 N:	meson
 
@@ -3101,14 +3101,14 @@ S:	Supported
 F:	drivers/mmc/host/cavium*
 
 CAVIUM LIQUIDIO NETWORK DRIVER
-M:     Derek Chickles <derek.chickles@caviumnetworks.com>
-M:     Satanand Burla <satananda.burla@caviumnetworks.com>
-M:     Felix Manlunas <felix.manlunas@caviumnetworks.com>
-M:     Raghu Vatsavayi <raghu.vatsavayi@caviumnetworks.com>
-L:     netdev@vger.kernel.org
-W:     http://www.cavium.com
-S:     Supported
-F:     drivers/net/ethernet/cavium/liquidio/
+M:	Derek Chickles <derek.chickles@caviumnetworks.com>
+M:	Satanand Burla <satananda.burla@caviumnetworks.com>
+M:	Felix Manlunas <felix.manlunas@caviumnetworks.com>
+M:	Raghu Vatsavayi <raghu.vatsavayi@caviumnetworks.com>
+L:	netdev@vger.kernel.org
+W:	http://www.cavium.com
+S:	Supported
+F:	drivers/net/ethernet/cavium/liquidio/
 
 CAVIUM OCTEON-TX CRYPTO DRIVER
 M:	George Cherian <george.cherian@cavium.com>
@@ -4327,14 +4327,14 @@ F:	include/uapi/drm/i915_drm.h
 F:	Documentation/gpu/i915.rst
 
 INTEL GVT-g DRIVERS (Intel GPU Virtualization)
-M:      Zhenyu Wang <zhenyuw@linux.intel.com>
-M:      Zhi Wang <zhi.a.wang@intel.com>
-L:      intel-gvt-dev@lists.freedesktop.org
-L:      intel-gfx@lists.freedesktop.org
-W:      https://01.org/igvt-g
-T:      git https://github.com/01org/gvt-linux.git
-S:      Supported
-F:      drivers/gpu/drm/i915/gvt/
+M:	Zhenyu Wang <zhenyuw@linux.intel.com>
+M:	Zhi Wang <zhi.a.wang@intel.com>
+L:	intel-gvt-dev@lists.freedesktop.org
+L:	intel-gfx@lists.freedesktop.org
+W:	https://01.org/igvt-g
+T:	git https://github.com/01org/gvt-linux.git
+S:	Supported
+F:	drivers/gpu/drm/i915/gvt/
 
 DRM DRIVERS FOR ATMEL HLCDC
 M:	Boris Brezillon <boris.brezillon@free-electrons.com>
@@ -4933,10 +4933,10 @@ F:	drivers/edac/skx_edac.c
 
 EDAC-XGENE
 APPLIED MICRO (APM) X-GENE SOC EDAC
-M:     Loc Ho <lho@apm.com>
-S:     Supported
-F:     drivers/edac/xgene_edac.c
-F:     Documentation/devicetree/bindings/edac/apm-xgene-edac.txt
+M:	Loc Ho <lho@apm.com>
+S:	Supported
+F:	drivers/edac/xgene_edac.c
+F:	Documentation/devicetree/bindings/edac/apm-xgene-edac.txt
 
 EDIROL UA-101/UA-1000 DRIVER
 M:	Clemens Ladisch <clemens@ladisch.de>
@@ -6778,11 +6778,11 @@ F:	drivers/net/ethernet/intel/
 F:	drivers/net/ethernet/intel/*/
 
 INTEL RDMA RNIC DRIVER
-M:     Faisal Latif <faisal.latif@intel.com>
-M:     Shiraz Saleem <shiraz.saleem@intel.com>
-L:     linux-rdma@vger.kernel.org
-S:     Supported
-F:     drivers/infiniband/hw/i40iw/
+M:	Faisal Latif <faisal.latif@intel.com>
+M:	Shiraz Saleem <shiraz.saleem@intel.com>
+L:	linux-rdma@vger.kernel.org
+S:	Supported
+F:	drivers/infiniband/hw/i40iw/
 
 INTEL MERRIFIELD GPIO DRIVER
 M:	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
@@ -6867,7 +6867,7 @@ W:	http://software.intel.com/en-us/mic-developer
 F:	include/linux/mic_bus.h
 F:	include/linux/scif.h
 F:	include/uapi/linux/mic_common.h
-F: 	include/uapi/linux/mic_ioctl.h
+F:	include/uapi/linux/mic_ioctl.h
 F:	include/uapi/linux/scif_ioctl.h
 F:	drivers/misc/mic/
 F:	drivers/dma/mic_x100_dma.c
@@ -8393,10 +8393,10 @@ F:	drivers/leds/leds-mlxcpld.c
 F:	Documentation/leds/leds-mlxcpld.txt
 
 MELLANOX PLATFORM DRIVER
-M:      Vadim Pasternak <vadimp@mellanox.com>
-L:      platform-driver-x86@vger.kernel.org
-S:      Supported
-F:      drivers/platform/x86/mlx-platform.c
+M:	Vadim Pasternak <vadimp@mellanox.com>
+L:	platform-driver-x86@vger.kernel.org
+S:	Supported
+F:	drivers/platform/x86/mlx-platform.c
 
 MELLANOX MLX CPLD HOTPLUG DRIVER
 M:	Vadim Pasternak <vadimp@mellanox.com>
@@ -9677,11 +9677,11 @@ F:	Documentation/mn10300/
 F:	arch/mn10300/
 
 PARALLEL LCD/KEYPAD PANEL DRIVER
-M:      Willy Tarreau <willy@haproxy.com>
-M:      Ksenija Stanojevic <ksenija.stanojevic@gmail.com>
-S:      Odd Fixes
-F:      Documentation/misc-devices/lcd-panel-cgram.txt
-F:      drivers/misc/panel.c
+M:	Willy Tarreau <willy@haproxy.com>
+M:	Ksenija Stanojevic <ksenija.stanojevic@gmail.com>
+S:	Odd Fixes
+F:	Documentation/misc-devices/lcd-panel-cgram.txt
+F:	drivers/misc/panel.c
 
 PARALLEL PORT SUBSYSTEM
 M:	Sudip Mukherjee <sudipm.mukherjee@gmail.com>
@@ -10002,11 +10002,11 @@ F:	Documentation/devicetree/bindings/pci/rockchip-pcie.txt
 F:	drivers/pci/host/pcie-rockchip.c
 
 PCIE DRIVER FOR QUALCOMM MSM
-M:     Stanimir Varbanov <svarbanov@mm-sol.com>
-L:     linux-pci@vger.kernel.org
-L:     linux-arm-msm@vger.kernel.org
-S:     Maintained
-F:     drivers/pci/dwc/*qcom*
+M:	Stanimir Varbanov <svarbanov@mm-sol.com>
+L:	linux-pci@vger.kernel.org
+L:	linux-arm-msm@vger.kernel.org
+S:	Maintained
+F:	drivers/pci/dwc/*qcom*
 
 PCIE DRIVER FOR CAVIUM THUNDERX
 M:	David Daney <david.daney@cavium.com>
@@ -10176,14 +10176,14 @@ S:	Maintained
 F:	drivers/pinctrl/spear/
 
 PISTACHIO SOC SUPPORT
-M:      James Hartley <james.hartley@imgtec.com>
-M:      Ionela Voinescu <ionela.voinescu@imgtec.com>
-L:      linux-mips@linux-mips.org
-S:      Maintained
-F:      arch/mips/pistachio/
-F:      arch/mips/include/asm/mach-pistachio/
-F:      arch/mips/boot/dts/img/pistachio*
-F:      arch/mips/configs/pistachio*_defconfig
+M:	James Hartley <james.hartley@imgtec.com>
+M:	Ionela Voinescu <ionela.voinescu@imgtec.com>
+L:	linux-mips@linux-mips.org
+S:	Maintained
+F:	arch/mips/pistachio/
+F:	arch/mips/include/asm/mach-pistachio/
+F:	arch/mips/boot/dts/img/pistachio*
+F:	arch/mips/configs/pistachio*_defconfig
 
 PKTCDVD DRIVER
 S:	Orphan
@@ -10667,12 +10667,12 @@ S:	Maintained
 F:	drivers/firmware/qemu_fw_cfg.c
 
 QUANTENNA QTNFMAC WIRELESS DRIVER
-M:   Igor Mitsyanko <imitsyanko@quantenna.com>
-M:   Avinash Patil <avinashp@quantenna.com>
-M:   Sergey Matyukevich <smatyukevich@quantenna.com>
-L:   linux-wireless@vger.kernel.org
-S:   Maintained
-F:   drivers/net/wireless/quantenna
+M:	Igor Mitsyanko <imitsyanko@quantenna.com>
+M:	Avinash Patil <avinashp@quantenna.com>
+M:	Sergey Matyukevich <smatyukevich@quantenna.com>
+L:	linux-wireless@vger.kernel.org
+S:	Maintained
+F:	drivers/net/wireless/quantenna
 
 RADOS BLOCK DEVICE (RBD)
 M:	Ilya Dryomov <idryomov@gmail.com>
@@ -13686,12 +13686,12 @@ F:	drivers/virtio/virtio_input.c
 F:	include/uapi/linux/virtio_input.h
 
 VIRTIO CRYPTO DRIVER
-M:  Gonglei <arei.gonglei@huawei.com>
-L:  virtualization@lists.linux-foundation.org
-L:  linux-crypto@vger.kernel.org
-S:  Maintained
-F:  drivers/crypto/virtio/
-F:  include/uapi/linux/virtio_crypto.h
+M:	Gonglei <arei.gonglei@huawei.com>
+L:	virtualization@lists.linux-foundation.org
+L:	linux-crypto@vger.kernel.org
+S:	Maintained
+F:	drivers/crypto/virtio/
+F:	include/uapi/linux/virtio_crypto.h
 
 VIA RHINE NETWORK DRIVER
 S:	Orphan
