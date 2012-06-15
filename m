Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:45749 "HELO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757441Ab2FOTcC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jun 2012 15:32:02 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v3 0/5] mwifiex: more changes for AP mode
Date: Fri, 15 Jun 2012 12:21:50 -0700
Message-Id: <1339788115-20596-1-git-send-email-bzhao@marvell.com> (sfid-20120615_213208_030235_76FAD9FF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avinash Patil (5):

  1/5 mwifiex: set channel via start_ap handler for AP interface
	v3: resending as 1/5, no change since v1
	v2: resending as 1/4, no change since v1

  2/5 mwifiex: parse WPA IE and support WPA/WPA2 mixed mode for uAP
	depends on "[PATCH] ieee80211: definitions for Microsoft Vendor OUI and WPA OUI type" (currently in mac80211-next.git)
	v3: resending as 2/5, no change since v1
	v2: resending as 2/4, no change since v1

  3/5 mwifiex: set HT capability based on cfg80211_ap_settings
	v3: changed subject (was "mwifiex: add 11n support for AP mode")
	v2: fixed sparse warnings

  4/5 mwifiex: separate uAP WPA/WPA2 parsing from other BSS parameters
	v3: resending as 4/5, no change since v1
	v2: resending as 4/4, no change since v1

  5/5 mwifiex: support for WEP in AP mode
	v3: newly addded to v3 series

 drivers/net/wireless/mwifiex/cfg80211.c |   55 +++++-
 drivers/net/wireless/mwifiex/fw.h       |   14 ++
 drivers/net/wireless/mwifiex/ie.c       |   55 ++++--
 drivers/net/wireless/mwifiex/ioctl.h    |   10 +
 drivers/net/wireless/mwifiex/main.h     |    4 +-
 drivers/net/wireless/mwifiex/uap_cmd.c  |  303 ++++++++++++++++++++-----------
 6 files changed, 312 insertions(+), 129 deletions(-)

