Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46594 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753811AbeFDOLY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Jun 2018 10:11:24 -0400
From: Balaji Pothunoori <bpothuno@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Balaji Pothunoori <bpothuno@codeaurora.org>
Subject: [PATCH v2 0/2] cfg80211/mac80211: last ack signal support in station dump
Date: Mon,  4 Jun 2018 19:41:07 +0530
Message-Id: <1528121469-16450-1-git-send-email-bpothuno@codeaurora.org> (sfid-20180604_161250_096607_0302C031)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds "last ack signal" support in station dump if
driver reports ack rssi for last tx packet.


Balaji Pothunoori (2):
  cfg80211: last ack signal support in station dump
  mac80211: last ack signal support in station dump

v2:
 - typo corrected in subject
 
 include/uapi/linux/nl80211.h | 14 +++++++-------
 net/mac80211/sta_info.c      | 20 ++++++++++++++------
 net/wireless/nl80211.c       |  8 ++++----
 3 files changed, 25 insertions(+), 17 deletions(-)

-- 
2.7.4
