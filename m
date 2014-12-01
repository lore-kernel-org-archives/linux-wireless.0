Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48251 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbaLANdm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2014 08:33:42 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 0/9] wil6210 fixes
Date: Mon, 1 Dec 2014 15:33:14 +0200
Message-ID: <1417440803-26883-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141201_143345_724564_1DACFBE0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Assorted fixes

Vladimir Kondratiev (9):
  wil6210: propagate disconnect reason
  wil6210: add handling of RX HTRSH interrupt
  wil6210: fix recovery after scan timeout
  wil6210: remove wil_to_pcie_dev()
  wil6210: configurable vring sizes
  wil6210: fix warning in pointer arithmetic
  wil6210: Rate limit "ring full" error message
  wil6210: reset flow update
  wil6210: remove TODO wrt buffer alignment

 drivers/net/wireless/ath/wil6210/cfg80211.c  |  2 +-
 drivers/net/wireless/ath/wil6210/debug.c     | 17 ++++++++
 drivers/net/wireless/ath/wil6210/fw.c        |  1 -
 drivers/net/wireless/ath/wil6210/fw_inc.c    |  4 +-
 drivers/net/wireless/ath/wil6210/interrupt.c | 30 +++++++++++--
 drivers/net/wireless/ath/wil6210/main.c      | 63 +++++++++++++++++++++-------
 drivers/net/wireless/ath/wil6210/txrx.c      | 11 +++--
 drivers/net/wireless/ath/wil6210/wil6210.h   | 15 ++++---
 drivers/net/wireless/ath/wil6210/wmi.c       |  8 ++--
 9 files changed, 114 insertions(+), 37 deletions(-)

-- 
2.1.0

