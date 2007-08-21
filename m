Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35356 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760552AbXHUPNV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 11:13:21 -0400
Message-Id: <20070821150046.903690000@sipsolutions.net>
References: <20070821145905.689978000@sipsolutions.net>
Date: Tue, 21 Aug 2007 16:59:22 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 17/27] mac80211: remove scan struct from hostapd_param
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This hasn't been used for quite a while.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/hostapd_ioctl.h |    8 --------
 1 file changed, 8 deletions(-)

--- wireless-dev.orig/net/mac80211/hostapd_ioctl.h	2007-08-21 14:40:14.195923881 +0200
+++ wireless-dev/net/mac80211/hostapd_ioctl.h	2007-08-21 14:40:16.755923881 +0200
@@ -156,14 +156,6 @@ struct prism2_hostapd_param {
 			u8 data[0] ALIGNED; /* num_modes * feature data */
 		} hw_features;
 		struct {
-			u8  now;
-			s8  our_mode_only;
-			s16 last_rx;
-			u16 channel;
-			s16 interval; /* seconds */
-			s32 listen;   /* microseconds */
-		} scan;
-		struct {
 			u16 mode; /* MODE_* */
 			u16 num_supported_rates;
 			u16 num_basic_rates;

-- 

