Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:32682 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932329AbaKMKyy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2014 05:54:54 -0500
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, <yangyang@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 0/6] mwifiex: auto TDLS support for mwifiex 
Date: Thu, 13 Nov 2014 21:54:12 +0530
Message-ID: <1415895858-4007-1-git-send-email-patila@marvell.com> (sfid-20141113_115500_578024_B53B5F90)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series adds auto TDLS support for mwifiex.

Avinash Patil (6):
  mwifiex: update rx packet descriptor structure to match FW
  mwifiex: do not explicitly disable TDLS link during teardown
  mwifiex: wmm support for TDLS link
  mwifiex: add auto TDLS support
  mwifiex: support for parsing TDLS discovery frames
  mwifiex: enable auto TDLS support for SD8887

 drivers/net/wireless/mwifiex/cfg80211.c  |   6 +
 drivers/net/wireless/mwifiex/decl.h      |   5 +
 drivers/net/wireless/mwifiex/fw.h        |   1 +
 drivers/net/wireless/mwifiex/init.c      |   5 +
 drivers/net/wireless/mwifiex/main.c      |   7 +
 drivers/net/wireless/mwifiex/main.h      |  31 +++-
 drivers/net/wireless/mwifiex/sdio.c      |   2 +
 drivers/net/wireless/mwifiex/sdio.h      |   7 +
 drivers/net/wireless/mwifiex/sta_event.c |   9 +-
 drivers/net/wireless/mwifiex/sta_rx.c    |   3 +
 drivers/net/wireless/mwifiex/tdls.c      | 288 +++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/util.c      |  38 ++++
 12 files changed, 397 insertions(+), 5 deletions(-)

-- 
1.8.1.4

