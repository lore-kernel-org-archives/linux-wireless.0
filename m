Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:57385 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756560AbaCOWRa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Mar 2014 18:17:30 -0400
Received: by mail-pa0-f43.google.com with SMTP id bj1so4143694pad.30
        for <linux-wireless@vger.kernel.org>; Sat, 15 Mar 2014 15:17:30 -0700 (PDT)
From: Fariya Fatima <fariyaf@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Fariya Fatima <fariyaf@gmail.com>
Subject: [PATCH v5 00/11] rsi: Adding RS9113 wireless driver.
Date: Sun, 16 Mar 2014 03:47:01 +0530
Message-Id: <1394921832-4056-1-git-send-email-fariyaf@gmail.com> (sfid-20140315_231800_383761_6F721E7B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Fariya Fatima <fariyaf@gmail.com>

This series of patches add the Redpine Signals' 91x wireless driver.

Fariya Fatima (11):
  This patch contains all the header files.
  This patch adds the remaining header files.
  This patch adds the files which contain functionality related     to
    initialization, queuing and de-queuing of packets to be     sent to
    the device, sending and receiving packets from the     device and
    OS interface operations.
  This patch adds the files relating to debugfs and relating to writing
    packets to device.
  This patch has MAC80211 callbacks to driver.
  This patch has the remaining functions which prepare management
    frames internal to the device.
  This patch has the remaining functions which prepare management
    frames internal to the device.
  This patch adds the USB functionality.
  This patch adds the SDIO functionality.
  This patch adds the remaining SDIO functionality.
  This patch contains changes/additions related to Makefile and
    Kconfig.

 drivers/net/wireless/Kconfig                |    1 +
 drivers/net/wireless/Makefile               |    1 +
 drivers/net/wireless/rsi/Kconfig            |   30 +
 drivers/net/wireless/rsi/Makefile           |   12 +
 drivers/net/wireless/rsi/rsi_91x_core.c     |  342 +++++++
 drivers/net/wireless/rsi/rsi_91x_debugfs.c  |  339 +++++++
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 1008 +++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_91x_main.c     |  270 ++++++
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     | 1302 +++++++++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_91x_pkt.c      |  196 ++++
 drivers/net/wireless/rsi/rsi_91x_sdio.c     |  850 +++++++++++++++++
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c |  566 ++++++++++++
 drivers/net/wireless/rsi/rsi_91x_usb.c      |  575 ++++++++++++
 drivers/net/wireless/rsi/rsi_91x_usb_ops.c  |  177 ++++
 drivers/net/wireless/rsi/rsi_boot_params.h  |  126 +++
 drivers/net/wireless/rsi/rsi_common.h       |   87 ++
 drivers/net/wireless/rsi/rsi_debugfs.h      |   48 +
 drivers/net/wireless/rsi/rsi_main.h         |  232 +++++
 drivers/net/wireless/rsi/rsi_mgmt.h         |  285 ++++++
 drivers/net/wireless/rsi/rsi_sdio.h         |  129 +++
 drivers/net/wireless/rsi/rsi_usb.h          |   68 ++
 21 files changed, 6644 insertions(+), 0 deletions(-)
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

