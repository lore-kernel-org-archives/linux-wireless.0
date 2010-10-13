Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:44229 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab0JMLI5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 07:08:57 -0400
From: csanjay@mistralsolutions.com
To: linux-omap@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
	Sanjay Kumar Champati <csanjay@mistralsolutions.com>
Subject: [RFC: WL1271 DC supprot on OMAP3EVM 0/5]
Date: Wed, 13 Oct 2010 16:27:14 +0530
Message-Id: <1286967439-705-1-git-send-email-csanjay@mistralsolutions.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sanjay Kumar Champati <csanjay@mistralsolutions.com>


Sanjay Kumar Champati (5):
  ARM: Supported MMC 2 features for OMAP3EVM
  ARM: Supported for Standard SDIO driver on OMAP3EVM for WL1271 DC
  ARM: Supported for BT enable on OMAP3EVM for WL1271 DC
  ARM: Added ALSA audio support for WL1271 DC over the PCM interface
    (OMAP37XX)
  Supported BT and WLAN configuration for WL1271 over the OMAP37XX

 arch/arm/configs/omap3_evm_defconfig |   27 +++++++-
 arch/arm/mach-omap2/board-omap3evm.c |   28 ++++++++-
 arch/arm/mach-omap2/mmc-twl4030.c    |    1 +
 arch/arm/mach-omap2/mmc-twl4030.h    |    2 +
 drivers/bluetooth/Kconfig            |    7 ++
 drivers/char/tty_io.c                |  110 ++++++++++++++++++++++++++++++++++
 drivers/mmc/core/sdio_ops.c          |    7 ++-
 drivers/net/wireless/Kconfig         |   11 ++++
 sound/soc/omap/Kconfig               |    6 ++
 sound/soc/omap/Makefile              |    2 +
 sound/soc/omap/omap3evm.c            |   81 ++++++++++++++++++++++++-
 sound/soc/omap/wl1271bt.c            |   59 ++++++++++++++++++
 sound/soc/omap/wl1271bt.h            |   16 +++++
 13 files changed, 350 insertions(+), 7 deletions(-)
 create mode 100644 sound/soc/omap/wl1271bt.c
 create mode 100644 sound/soc/omap/wl1271bt.h

