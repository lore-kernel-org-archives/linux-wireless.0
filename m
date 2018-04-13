Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37012 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750960AbeDMLdL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Apr 2018 07:33:11 -0400
From: Balaji Pothunoori <bpothuno@codeaurora.org>
To: linux-wireless@vger.kernel.org
Cc: bpothuno@codeaurora.org
Subject: [PATCH 0/3]: cfg80211/mac80211/ath10k: average ack rssi support for data frames
Date: Fri, 13 Apr 2018 17:02:54 +0530
Message-Id: <1523619177-1816-1-git-send-email-bpothuno@codeaurora.org> (sfid-20180413_133316_257608_CF647619)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset introduces the average ack rssi for data frames. 


Balaji Pothunoori (1):
  ath10k: average ack rssi support for data frames.
  mac80211: average ack rssi support for data frames
  cfg80211: average ack rssi support for data frames  

 drivers/net/wireless/ath/ath10k/core.c   |  4 ++++
 drivers/net/wireless/ath/ath10k/htt.h    |  6 +++++-
 drivers/net/wireless/ath/ath10k/htt_rx.c | 21 +++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/mac.c    |  4 ++++
 drivers/net/wireless/ath/ath10k/wmi.h    |  8 ++++++++
 net/mac80211/sta_info.c | 10 ++++++++++
 net/mac80211/sta_info.h |  2 ++
 net/mac80211/status.c   |  2 ++
 include/net/cfg80211.h       | 3 +++
 include/uapi/linux/nl80211.h | 7 +++++++
 net/wireless/nl80211.c       | 3 +++

 11 files changed, 69 insertions(+), 1 deletion(-)

-- 
2.7.4
