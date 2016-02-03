Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:13313 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892AbcBCPiZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 10:38:25 -0500
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Subject: [PATCH 0/2] Peer Stats fixes for rx duration
Date: Wed, 3 Feb 2016 21:07:41 +0530
Message-ID: <1454513863-2703-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20160203_163828_714741_09E685D5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

This is a small patchset that fixes:

1. Updating rx duration per station (part of mac80211 STA debugfs)
irrespective user does a cat fw_stats in ath10k debugfs

2. Remove updating peer stats list (which is completely useless)
when we recieve periodic update of peer stats for updating rx_duration

Mohammed Shafi Shajakhan (2):
  ath10k: Fix updating peer stats rx duration
  ath10k: Fix pointless update of peer stats list

 drivers/net/wireless/ath/ath10k/debug.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

-- 
1.7.9.5

