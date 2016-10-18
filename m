Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8682 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933204AbcJRJb1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Oct 2016 05:31:27 -0400
From: <akolli@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <akolli@codeaurora.org>
Subject: [PATCHv2 0/2] ath10k: add support for tx bitrate
Date: Tue, 18 Oct 2016 15:01:23 +0530
Message-ID: <1476783085-10724-1-git-send-email-akolli@qti.qualcomm.com> (sfid-20161018_113130_411075_CCBDC782)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Anilkumar Kolli <akolli@codeaurora.org>

This patch series adds support for tx bitrate using 
.sta_statistics callback.

tx bitrate tested on QCA4019 using iw.

Anilkumar Kolli (2):
  ath10k: add per peer htt tx stats support for 10.4
  ath10k: add support for per sta tx bitrate

 drivers/net/wireless/ath/ath10k/core.h        |   17 ++++
 drivers/net/wireless/ath/ath10k/debugfs_sta.c |   13 +++
 drivers/net/wireless/ath/ath10k/htt.c         |    2 +
 drivers/net/wireless/ath/ath10k/htt.h         |   25 +++++
 drivers/net/wireless/ath/ath10k/htt_rx.c      |  125 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h         |   10 +-
 6 files changed, 191 insertions(+), 1 deletion(-)

-- 
1.7.9.5
