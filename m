Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:38826 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab1CPCmw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 22:42:52 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 0/6] remove configuration APIs from debugfs (part 1)
Date: Tue, 15 Mar 2011 19:46:04 -0700
Message-Id: <1300243570-6798-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series removes some of the configuration APIs.

Bing Zhao (2):
  mwifiex: remove atimwindow command from debugfs
  mwifiex: remove deepsleep command from debugfs

Kiran Divekar (3):
  mwifiex: remove addbapara configuration from debugfs
  mwifiex: remove addbareject configuration from debugfs
  mwifiex: remove txaggrprio command from debugfs

Marc Yang (1):
  mwifiex: remove htcapinfo command from debugfs

 drivers/net/wireless/mwifiex/11n.c           |  169 ---------
 drivers/net/wireless/mwifiex/11n.h           |    9 -
 drivers/net/wireless/mwifiex/11n_rxreorder.c |    6 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.h |    1 -
 drivers/net/wireless/mwifiex/README          |  161 --------
 drivers/net/wireless/mwifiex/debugfs.c       |  521 --------------------------
 drivers/net/wireless/mwifiex/fw.h            |    2 -
 drivers/net/wireless/mwifiex/init.c          |    3 -
 drivers/net/wireless/mwifiex/ioctl.h         |   11 -
 drivers/net/wireless/mwifiex/join.c          |    1 -
 drivers/net/wireless/mwifiex/main.h          |   24 --
 drivers/net/wireless/mwifiex/sta_cmdresp.c   |    4 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c     |  288 --------------
 13 files changed, 2 insertions(+), 1198 deletions(-)

