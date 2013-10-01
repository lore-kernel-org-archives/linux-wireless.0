Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:52145 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752238Ab3JATTz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 15:19:55 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-bluetooth@vger.kernel.org>
CC: Marcel Holtmann <marcel@holtmann.org>,
	Gustavo Padovan <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	<linux-wireless@vger.kernel.org>,
	Mike Frysinger <vapier@chromium.org>,
	Hyuckjoo Lee <hyuckjoo.lee@samsung.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v6 0/4] Bluetooth: btmrvl cal data downloading
Date: Tue, 1 Oct 2013 12:19:11 -0700
Message-ID: <1380655155-10007-1-git-send-email-bzhao@marvell.com> (sfid-20131001_212000_852468_17B1F714)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series adds the calibration data downloading support
along with improvements in sending commands and setup handler.

Amitkumar Karwar (4):
  Bluetooth: btmrvl: add btmrvl_send_sync_cmd() function
  Bluetooth: btmrvl: get rid of struct btmrvl_cmd
  Bluetooth: btmrvl: add setup handler
  Bluetooth: btmrvl: add calibration data download support

 drivers/bluetooth/btmrvl_drv.h  |  12 +-
 drivers/bluetooth/btmrvl_main.c | 269 ++++++++++++++++++++++++++--------------
 drivers/bluetooth/btmrvl_sdio.c |  15 +--
 drivers/bluetooth/btmrvl_sdio.h |   2 +
 4 files changed, 193 insertions(+), 105 deletions(-)

-- 
1.8.0

