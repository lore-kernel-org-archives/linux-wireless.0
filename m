Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48958 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758166AbcFHRHx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2016 13:07:53 -0400
From: Maya Erez <qca_merez@qualcomm.com>
Cc: Maya Erez <qca_merez@qualcomm.com>, linux-wireless@vger.kernel.org,
	wil6210@qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 0/2] wil6210 patches
Date: Wed,  8 Jun 2016 20:07:46 +0300
Message-Id: <1465405668-15881-1-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160608_190757_216596_9C8C383B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wil6210 P2P fixes

Lior David (1):
  wil6210: abort P2P search when stopping P2P device

Maya Erez (1):
  wil6210: fix chan check in wil_p2p_listen

 drivers/net/wireless/ath/wil6210/cfg80211.c | 16 ++++++++++++++++
 drivers/net/wireless/ath/wil6210/p2p.c      |  6 ++++--
 drivers/net/wireless/ath/wil6210/wil6210.h  |  1 +
 3 files changed, 21 insertions(+), 2 deletions(-)

-- 
1.8.5.2

