Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:59903 "HELO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758467Ab2DJDHf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2012 23:07:35 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 0/5] mwifiex: patches for 3.5
Date: Mon,  9 Apr 2012 20:06:52 -0700
Message-Id: <1334027217-23724-1-git-send-email-bzhao@marvell.com> (sfid-20120410_050737_334343_17B479D8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This patch series is intended for 3.5.

Please note that "[PATCH 5/5] mwifiex: use asynchronous firmware loading"
depends on "[PATCH 14/26] wireless, mwifiex: drop redundant NULL test
before call to release_firmware()" (Jesper Juhl).

Thanks,
Bing

---
Amitkumar Karwar (3):
  mwifiex: set default regulatory domain
  mwifiex: display correct country information in debugfs "info"
  mwifiex: use asynchronous firmware loading

Avinash Patil (1):
  mwifiex: add support for WPS2.0

Bing Zhao (1):
  mwifiex: fix typo in RSSI_HIGH event handling

 drivers/net/wireless/mwifiex/cfg80211.c  |   27 ++++++++
 drivers/net/wireless/mwifiex/cfp.c       |   31 +++++++++
 drivers/net/wireless/mwifiex/debugfs.c   |    2 +-
 drivers/net/wireless/mwifiex/fw.h        |    1 +
 drivers/net/wireless/mwifiex/init.c      |    2 +
 drivers/net/wireless/mwifiex/ioctl.h     |    3 +-
 drivers/net/wireless/mwifiex/join.c      |   44 +++++++++++++
 drivers/net/wireless/mwifiex/main.c      |  103 ++++++++++++++++--------------
 drivers/net/wireless/mwifiex/main.h      |    4 +
 drivers/net/wireless/mwifiex/pcie.c      |    3 +
 drivers/net/wireless/mwifiex/sdio.c      |    3 +
 drivers/net/wireless/mwifiex/sta_cmd.c   |    2 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c |   37 ++++++++++-
 13 files changed, 210 insertions(+), 52 deletions(-)

