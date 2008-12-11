Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:61978 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428AbYLKMAl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 07:00:41 -0500
Received: by wf-out-1314.google.com with SMTP id 27so705914wfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 11 Dec 2008 04:00:41 -0800 (PST)
Message-ID: <eb3ff54b0812110400l7e824b9el65aefb4ff416b30d@mail.gmail.com> (sfid-20081211_130044_306935_7AA0E56E)
Date: Thu, 11 Dec 2008 14:00:41 +0200
From: "Rami Rosen" <ramirose@gmail.com>
To: linville@tuxdriver.com
Subject: [PATCH 2/2] mac80211: misc cleanups
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unneeded member from struct ieee80211_rx_data
in ieee80211_i.h.

(wireless-testing).

Signed-off-by: Rami Rosen <ramirose@gmail.com>

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 527205f..aacc761 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -187,7 +187,6 @@ struct ieee80211_rx_data {
 	struct ieee80211_rx_status *status;
 	struct ieee80211_rate *rate;

-	u16 ethertype;
 	unsigned int flags;
 	int sent_ps_buffered;
 	int queue;
