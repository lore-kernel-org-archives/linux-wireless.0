Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28727 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752298AbcJGO7K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Oct 2016 10:59:10 -0400
From: <akolli@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <akolli@codeaurora.org>
Subject: [PATCH 0/2] ath10k: add support for tx bitrate
Date: Fri, 7 Oct 2016 20:28:50 +0530
Message-ID: <1475852332-18217-1-git-send-email-akolli@qti.qualcomm.com> (sfid-20161007_165913_975142_34A092AA)
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
