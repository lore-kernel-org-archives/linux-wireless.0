Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:47447 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516AbaCJP0s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2014 11:26:48 -0400
Received: by mail-pb0-f53.google.com with SMTP id rp16so7353625pbb.26
        for <linux-wireless@vger.kernel.org>; Mon, 10 Mar 2014 08:26:47 -0700 (PDT)
From: fariyaf@gmail.com
To: linux-wireless@vger.kernel.org
Cc: Fariya Fatima <fariyaf@gmail.com>
Subject: [PATCH v4 00/11] rsi: Adding RS9113 wireless driver.
Date: Mon, 10 Mar 2014 20:56:28 +0530
Message-Id: <1394465199-10042-1-git-send-email-fariyaf@gmail.com> (sfid-20140310_162652_095079_A6E48AAC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Fariya Fatima <fariyaf@gmail.com>

This series of patches adds Redpine Signals wireless driver.

Fariya Fatima (11):
  Adding RS9113 driver header files
  Adding remaining header files
  Adding core and main files.
  Writing packets to device and debugfs.
  MAC80211 callbacks to driver.
  MAC80211 callbacks and management functions internal to device.
  Management functions internal to the device.
  USB functionality
  SDIO functionality.
  Remaining SDIO functionality.
  Makefile and Kconfig

 drivers/net/wireless/Kconfig                |    1 +
 drivers/net/wireless/Makefile               |    1 +
 drivers/net/wireless/rsi/Kconfig            |   30 +
 drivers/net/wireless/rsi/Makefile           |   12 +
 drivers/net/wireless/rsi/rsi_91x_core.c     |  342 +++++++
 drivers/net/wireless/rsi/rsi_91x_debugfs.c  |  339 +++++++
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 1008 +++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_91x_main.c     |  270 ++++++
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     | 1302 +++++++++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_91x_pkt.c      |  195 ++++
 drivers/net/wireless/rsi/rsi_91x_sdio.c     |  845 +++++++++++++++++
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c |  566 ++++++++++++
 drivers/net/wireless/rsi/rsi_91x_usb.c      |  572 ++++++++++++
 drivers/net/wireless/rsi/rsi_91x_usb_ops.c  |  177 ++++
 drivers/net/wireless/rsi/rsi_boot_params.h  |  126 +++
 drivers/net/wireless/rsi/rsi_common.h       |   87 ++
 drivers/net/wireless/rsi/rsi_debugfs.h      |   48 +
 drivers/net/wireless/rsi/rsi_main.h         |  232 +++++
 drivers/net/wireless/rsi/rsi_mgmt.h         |  285 ++++++
 drivers/net/wireless/rsi/rsi_sdio.h         |  129 +++
 drivers/net/wireless/rsi/rsi_usb.h          |   70 ++
 21 files changed, 6637 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/rsi/Kconfig
 create mode 100644 drivers/net/wireless/rsi/Makefile
 create mode 100644 drivers/net/wireless/rsi/rsi_91x_core.c
 create mode 100644 drivers/net/wireless/rsi/rsi_91x_debugfs.c
 create mode 100644 drivers/net/wireless/rsi/rsi_91x_mac80211.c
 create mode 100644 drivers/net/wireless/rsi/rsi_91x_main.c
 create mode 100644 drivers/net/wireless/rsi/rsi_91x_mgmt.c
 create mode 100644 drivers/net/wireless/rsi/rsi_91x_pkt.c
 create mode 100644 drivers/net/wireless/rsi/rsi_91x_sdio.c
 create mode 100644 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
 create mode 100644 drivers/net/wireless/rsi/rsi_91x_usb.c
 create mode 100644 drivers/net/wireless/rsi/rsi_91x_usb_ops.c
 create mode 100644 drivers/net/wireless/rsi/rsi_boot_params.h
 create mode 100644 drivers/net/wireless/rsi/rsi_common.h
 create mode 100644 drivers/net/wireless/rsi/rsi_debugfs.h
 create mode 100644 drivers/net/wireless/rsi/rsi_main.h
 create mode 100644 drivers/net/wireless/rsi/rsi_mgmt.h
 create mode 100644 drivers/net/wireless/rsi/rsi_sdio.h
 create mode 100644 drivers/net/wireless/rsi/rsi_usb.h

-- 
1.7.5.4

