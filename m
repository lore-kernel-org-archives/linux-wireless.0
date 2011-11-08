Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:59268 "HELO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750957Ab1KHFl3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 00:41:29 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 0/7] mwifiex: patch series for 3.3
Date: Mon,  7 Nov 2011 21:41:05 -0800
Message-Id: <1320730872-25619-1-git-send-email-bzhao@marvell.com> (sfid-20111108_064133_040272_4BE1190E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series includes a fix for memory leak (7/7) and some code cleanups.

Thanks,
Bing
---

Amitkumar Karwar (2):
  mwifiex: remove unnecessary free_priv handler
  mwifiex: release bss structure returned by cfg80211_inform_bss()

Yogesh Ashok Powar (5):
  mwifiex: fix ht_cap_info in ibss beacons
  mwifiex: use existing helper function mwifiex_fill_cap_info
  mwifiex: change return types to void
  mwifiex: fix coding style
  mwifiex: fix 'Smatch' warnings

 drivers/net/wireless/mwifiex/11n_rxreorder.c |   18 ++---
 drivers/net/wireless/mwifiex/cfg80211.c      |    4 +-
 drivers/net/wireless/mwifiex/fw.h            |    2 +-
 drivers/net/wireless/mwifiex/init.c          |    4 +-
 drivers/net/wireless/mwifiex/join.c          |   96 +++++++++++---------------
 drivers/net/wireless/mwifiex/scan.c          |    7 +--
 drivers/net/wireless/mwifiex/sta_rx.c        |   12 ++--
 7 files changed, 60 insertions(+), 83 deletions(-)

