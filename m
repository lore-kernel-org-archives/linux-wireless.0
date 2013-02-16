Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:37126 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751086Ab3BPFpx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Feb 2013 00:45:53 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 0/2] mwifiex: support 11ac for 8897
Date: Fri, 15 Feb 2013 21:44:28 -0800
Message-Id: <1360993470-4828-1-git-send-email-bzhao@marvell.com> (sfid-20130216_064557_261388_AC7E2FFE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series adds 11ac feature for 8897.

Yogesh Ashok Powar (2):
  mwifiex: coding style cleanup in bss parameter update
  mwifiex: add 802.11AC support

 drivers/net/wireless/mwifiex/11ac.c        |  261 ++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/11ac.h        |   26 +++
 drivers/net/wireless/mwifiex/11n.c         |    7 +-
 drivers/net/wireless/mwifiex/11n.h         |    4 +-
 drivers/net/wireless/mwifiex/Makefile      |    1 +
 drivers/net/wireless/mwifiex/cfg80211.c    |  177 ++++++++++++++++---
 drivers/net/wireless/mwifiex/cfp.c         |  159 +++++++++++++++++-
 drivers/net/wireless/mwifiex/cmdevt.c      |   19 ++
 drivers/net/wireless/mwifiex/fw.h          |  127 +++++++++++++-
 drivers/net/wireless/mwifiex/ioctl.h       |    4 +
 drivers/net/wireless/mwifiex/join.c        |    8 +
 drivers/net/wireless/mwifiex/main.h        |   23 +++-
 drivers/net/wireless/mwifiex/scan.c        |   63 ++++++-
 drivers/net/wireless/mwifiex/sta_cmd.c     |    2 +-
 drivers/net/wireless/mwifiex/sta_cmdresp.c |    1 +
 drivers/net/wireless/mwifiex/sta_ioctl.c   |    5 +-
 16 files changed, 835 insertions(+), 52 deletions(-)
 create mode 100644 drivers/net/wireless/mwifiex/11ac.c
 create mode 100644 drivers/net/wireless/mwifiex/11ac.h

