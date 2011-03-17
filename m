Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:51473 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340Ab1CQWNy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2011 18:13:54 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 0/3] remove configuration APIs from debugfs (part 3)
Date: Thu, 17 Mar 2011 15:17:09 -0700
Message-Id: <1300400232-13424-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series removes the remaining debugfs configuration APIs

Bing Zhao (3):
  mwifiex: remove hscfg command from debugfs
  mwifiex: remove qoscfg from debugfs
  mwifiex: remove sleeppd from debugfs

 drivers/net/wireless/mwifiex/README        |   61 -------
 drivers/net/wireless/mwifiex/debugfs.c     |  245 ----------------------------
 drivers/net/wireless/mwifiex/fw.h          |    7 -
 drivers/net/wireless/mwifiex/ioctl.h       |    3 -
 drivers/net/wireless/mwifiex/main.h        |    9 +-
 drivers/net/wireless/mwifiex/sta_cmd.c     |   31 ----
 drivers/net/wireless/mwifiex/sta_cmdresp.c |   39 -----
 drivers/net/wireless/mwifiex/sta_ioctl.c   |  126 +--------------
 8 files changed, 5 insertions(+), 516 deletions(-)

