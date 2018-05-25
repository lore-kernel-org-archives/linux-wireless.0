Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42936 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750869AbeEYJUf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 May 2018 05:20:35 -0400
From: Balaji Pothunoori <bpothuno@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Balaji Pothunoori <bpothuno@qti.qualcomm.com>
Subject: [PATCH 0/2] cfg80211/mac80211: last ack singal support in station dump
Date: Fri, 25 May 2018 14:50:03 +0530
Message-Id: <1527240005-8508-1-git-send-email-bpothuno@codeaurora.org> (sfid-20180525_112049_036026_B6C4267A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Balaji Pothunoori <bpothuno@qti.qualcomm.com>

This patch adds "last ack signal" support in station dump if
driver reports ack rssi for last tx packet.


Balaji Pothunoori (2):
  cfg80211: last ack singal support in station dump
  mac80211: last ack singal support in station dump

 include/uapi/linux/nl80211.h | 14 +++++++-------
 net/mac80211/sta_info.c      | 20 ++++++++++++++------
 net/wireless/nl80211.c       |  8 ++++----
 3 files changed, 25 insertions(+), 17 deletions(-)

-- 
2.7.4
