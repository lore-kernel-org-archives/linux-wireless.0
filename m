Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:50270 "HELO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751668Ab2GNDL5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2012 23:11:57 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 0/4] mwifiex: patchset for data rate enhancement
Date: Fri, 13 Jul 2012 20:09:29 -0700
Message-Id: <1342235373-27613-1-git-send-email-bzhao@marvell.com> (sfid-20120714_051238_828303_F16FA64F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series includes data rate releated code cleanups and
set_bitrate_mask enhancement.

Amitkumar Karwar (4):
  mwifiex: remove redundant code in set channel path
  mwifiex: remove unnecessary code in data rate configuration
  mwifiex: add support to use basic rates in ibss join request
  mwifiex: improvement in cfg80211 set_bitrate_mask handler

 drivers/net/wireless/mwifiex/cfg80211.c    |  256 +++++++++++++------------
 drivers/net/wireless/mwifiex/cfp.c         |   31 ---
 drivers/net/wireless/mwifiex/decl.h        |    9 -
 drivers/net/wireless/mwifiex/fw.h          |   10 -
 drivers/net/wireless/mwifiex/init.c        |    1 -
 drivers/net/wireless/mwifiex/ioctl.h       |    6 -
 drivers/net/wireless/mwifiex/main.h        |   10 +-
 drivers/net/wireless/mwifiex/sta_cmd.c     |   38 ----
 drivers/net/wireless/mwifiex/sta_cmdresp.c |   70 +------
 drivers/net/wireless/mwifiex/sta_ioctl.c   |  287 +---------------------------
 10 files changed, 151 insertions(+), 567 deletions(-)

