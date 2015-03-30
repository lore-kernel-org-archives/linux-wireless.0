Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3625 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872AbbC3I3R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 04:29:17 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 0/5] wil6210 patches
Date: Mon, 30 Mar 2015 11:28:49 +0300
Message-Id: <1427704134-30699-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150330_102921_326031_85404CF1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Small bits here and there.
Cosmetic but visible is firmware name change

Vladimir Kondratiev (5):
  wil6210: fw debug mode
  wil6210: debug [add|del]_key operations
  wil6210: trace disconnect source
  wil6210: stop_ap to leave interface closed
  wil6210: update FW file name

 drivers/net/wireless/ath/wil6210/cfg80211.c | 15 +++++++++++----
 drivers/net/wireless/ath/wil6210/main.c     | 15 +++++++++++++++
 drivers/net/wireless/ath/wil6210/netdev.c   |  5 +++++
 drivers/net/wireless/ath/wil6210/pcie_bus.c |  6 ------
 drivers/net/wireless/ath/wil6210/wil6210.h  |  3 ++-
 5 files changed, 33 insertions(+), 11 deletions(-)

-- 
2.1.0

