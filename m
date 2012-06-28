Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:36781 "HELO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932243Ab2F1C6w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 22:58:52 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 0/4] mwifiex: tx power improvements
Date: Wed, 27 Jun 2012 19:57:55 -0700
Message-Id: <1340852279-24964-1-git-send-email-bzhao@marvell.com> (sfid-20120628_045906_004118_72B1CE2C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset improves tx power handling.

---
Amitkumar Karwar (4):
  mwifiex: wakeup main thread to handle command queued
  mwifiex: use correct firmware command to get power limits
  mwifiex: do not advertise custom regulatory domain capability
  mwifiex: retrieve correct max_power information in reg_notifier
    handler

 drivers/net/wireless/mwifiex/cfg80211.c    |   10 +++++-----
 drivers/net/wireless/mwifiex/cmdevt.c      |    1 +
 drivers/net/wireless/mwifiex/fw.h          |    9 +++++++++
 drivers/net/wireless/mwifiex/main.h        |    4 ++--
 drivers/net/wireless/mwifiex/scan.c        |   25 +++----------------------
 drivers/net/wireless/mwifiex/sta_cmd.c     |   23 ++++++++++++++++++++++-
 drivers/net/wireless/mwifiex/sta_cmdresp.c |   27 +++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/sta_ioctl.c   |    3 ---
 8 files changed, 69 insertions(+), 33 deletions(-)

