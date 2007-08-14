Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57158 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758071AbXHNLry (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 07:47:54 -0400
Message-Id: <20070814092444.984747000@sipsolutions.net>
References: <20070814092008.627058000@sipsolutions.net>
Date: Tue, 14 Aug 2007 11:20:17 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 09/13] mac80211: remove scan struct from hostapd_param
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This hasn't been used for quite a while.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/hostapd_ioctl.h |    8 --------
 1 file changed, 8 deletions(-)

--- wireless-dev.orig/net/mac80211/hostapd_ioctl.h	2007-08-14 00:27:31.475589257 +0200
+++ wireless-dev/net/mac80211/hostapd_ioctl.h	2007-08-14 00:27:32.715589257 +0200
@@ -127,14 +127,6 @@ struct prism2_hostapd_param {
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

