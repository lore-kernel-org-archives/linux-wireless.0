Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37382 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750799AbeDPOsu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Apr 2018 10:48:50 -0400
From: Balaji Pothunoori <bpothuno@codeaurora.org>
To: johannes@sipsolutions.net, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, bpothuno@codeaurora.org
Subject: [PATCHv2 0/3]: cfg80211/mac80211/ath10k: average ack rssi support for data frames
Date: Mon, 16 Apr 2018 20:18:39 +0530
Message-Id: <1523890122-23952-1-git-send-email-bpothuno@codeaurora.org> (sfid-20180416_164854_666858_B341557B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset introduces the average ack rssi for data frames. 


Balaji Pothunoori (3):
  ath10k: average ack rssi support for data frames.
  mac80211: average ack rssi support for data frames
  cfg80211: average ack rssi support for data frames  

v2:
	Addressed ath10k-check warnings

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
