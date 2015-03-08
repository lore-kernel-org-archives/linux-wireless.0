Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43602 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbbCHNmJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Mar 2015 09:42:09 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 0/3] wil6210 patches
Date: Sun,  8 Mar 2015 15:42:00 +0200
Message-Id: <1425822123-24668-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150308_144214_266261_229AC2A6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Take care of AP bridging;
and fix NAPI behavior

Vladimir Kondratiev (3):
  wil6210: NAPI completion refactor
  wil6210: re-submit Rx frames to the wireless media if appropriate
  wil6210: support AP isolation

 drivers/net/wireless/ath/wil6210/cfg80211.c | 16 +++++++
 drivers/net/wireless/ath/wil6210/debugfs.c  |  1 +
 drivers/net/wireless/ath/wil6210/main.c     |  1 +
 drivers/net/wireless/ath/wil6210/netdev.c   |  4 +-
 drivers/net/wireless/ath/wil6210/txrx.c     | 72 +++++++++++++++++++++++------
 drivers/net/wireless/ath/wil6210/wil6210.h  |  1 +
 6 files changed, 79 insertions(+), 16 deletions(-)

-- 
2.1.0

