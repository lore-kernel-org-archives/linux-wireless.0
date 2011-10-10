Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35065 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab1JJKpT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 06:45:19 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 0/5] ath6kl: Debugging and roaming
Date: Mon, 10 Oct 2011 13:43:26 +0300
Message-ID: <1318243411-16110-1-git-send-email-jouni@qca.qualcomm.com> (sfid-20111010_124523_993316_7CEC35FE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This set of patches adds some more ath6kl debugging information and
control to debugfs and enables additional roaming functionality.

Jouni Malinen (5):
  ath6kl: Add endpoint_stats debugfs file
  ath6kl: Add debugfs file for target roam table
  ath6kl: Add debugfs files for roaming control
  ath6kl: Add debugfs control for keepalive and disconnection timeout
  ath6kl: Allow CCKM AKM and KRK to be configured

 drivers/net/wireless/ath/ath6kl/cfg80211.c |   14 ++
 drivers/net/wireless/ath/ath6kl/core.h     |    7 +
 drivers/net/wireless/ath/ath6kl/debug.c    |  346 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.c      |   89 +++++++
 drivers/net/wireless/ath/ath6kl/wmi.h      |   28 ++-
 5 files changed, 478 insertions(+), 6 deletions(-)

-- 
1.7.4.1

