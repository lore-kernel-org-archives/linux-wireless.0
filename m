Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8519 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbaE0Lqa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 07:46:30 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 0/7] wil6210 patches
Date: Tue, 27 May 2014 14:45:43 +0300
Message-ID: <1401191150-29037-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140527_134634_964336_B8106BF0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Small fixes here and there; with notable exceptions for the
"detect scan timeouts", which is attempt to fix buggy
firmware behavior

Vladimir Kondratiev (7):
  wil6210: limit MTU
  wil6210: limit fw error recovery attempts
  wil6210: inline functions for vring hi/lo watermarks
  wil6210: improve debug for WMI receive
  wil6210: detect scan timeouts
  wil6210: improve pointers printing
  wil6210: optimize wil_release_reorder_frames

 drivers/net/wireless/ath/wil6210/cfg80211.c   |  1 +
 drivers/net/wireless/ath/wil6210/debugfs.c    |  4 +--
 drivers/net/wireless/ath/wil6210/main.c       | 35 ++++++++++++++++++++++++++-
 drivers/net/wireless/ath/wil6210/netdev.c     | 14 +++++++++++
 drivers/net/wireless/ath/wil6210/pcie_bus.c   |  2 +-
 drivers/net/wireless/ath/wil6210/rx_reorder.c |  9 ++++++-
 drivers/net/wireless/ath/wil6210/txrx.c       | 28 ++++++++++++++++-----
 drivers/net/wireless/ath/wil6210/wil6210.h    |  6 +++++
 drivers/net/wireless/ath/wil6210/wmi.c        | 23 ++++++++++++------
 9 files changed, 104 insertions(+), 18 deletions(-)

-- 
1.9.1

