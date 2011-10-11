Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64552 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312Ab1JKOc3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 10:32:29 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH v2 0/5] ath6kl: Debugging and roaming
Date: Tue, 11 Oct 2011 17:31:52 +0300
Message-ID: <1318343517-15292-1-git-send-email-jouni@qca.qualcomm.com> (sfid-20111011_163232_549423_D0007F8B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This set of patches adds some more ath6kl debugging information and
control to debugfs and enables additional roaming functionality.

v2 addresses the comments from Kalle to move debug functionality in
patches 2 and 4 to debug.c.

Jouni Malinen (5):
  ath6kl: Add endpoint_stats debugfs file
  ath6kl: Add debugfs file for target roam table
  ath6kl: Add debugfs files for roaming control
  ath6kl: Add debugfs control for keepalive and disconnection timeout
  ath6kl: Allow CCKM AKM and KRK to be configured

 drivers/net/wireless/ath/ath6kl/cfg80211.c |   14 +
 drivers/net/wireless/ath/ath6kl/core.h     |    7 +
 drivers/net/wireless/ath/ath6kl/debug.c    |  390 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/debug.h    |   19 ++
 drivers/net/wireless/ath/ath6kl/wmi.c      |   55 ++++
 drivers/net/wireless/ath/ath6kl/wmi.h      |   28 ++-
 6 files changed, 507 insertions(+), 6 deletions(-)

-- 
1.7.4.1

