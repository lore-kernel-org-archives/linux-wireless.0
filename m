Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49776 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756927Ab1DLKmu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 06:42:50 -0400
Received: by eyx24 with SMTP id 24so1980986eyx.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 03:42:48 -0700 (PDT)
Subject: [PATCH 1/4] cfg80211: Add channel type for IBSS
From: Alexander Simon <alexander.simon@saxnet.de>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Apr 2011 12:42:44 +0200
Message-ID: <1302604964.2139.5.camel@alex-2>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Needed for IBSS IEEE802.11N operation

* Add ht channel type for cfg80211 IBSS configuration

Signed-off-by: Alexander Simon <alexander.simon@saxnet.de>
---
 cfg80211.h |    1 +
 1 file changed, 1 insertion(+)

diff -Nrup a/include/net/cfg80211.h b/include/net/cfg80211.h
--- a/include/net/cfg80211.h	2011-03-31 21:04:02.000000000 +0200
+++ b/include/net/cfg80211.h	2011-04-12 08:49:19.000000000 +0200
@@ -964,6 +964,7 @@ struct cfg80211_ibss_params {
 	u8 *ssid;
 	u8 *bssid;
 	struct ieee80211_channel *channel;
+	enum nl80211_channel_type channel_type;
 	u8 *ie;
 	u8 ssid_len, ie_len;
 	u16 beacon_interval;


