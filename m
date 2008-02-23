Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42889 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842AbYBWOV6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Feb 2008 09:21:58 -0500
Message-Id: <20080223142008.570151000@sipsolutions.net> (sfid-20080223_142342_720104_84575097)
References: <20080223141703.194775000@sipsolutions.net>
Date: Sat, 23 Feb 2008 15:17:05 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Luis Carlos Cobo <luisca@cozybit.com>
Subject: [PATCH 02/18] WEXT: add mesh interface type
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This introduces a new WEXT type IW_MODE_MESH for mesh networks,
used for scan results.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/wireless.h |    1 +
 1 file changed, 1 insertion(+)

--- everything.orig/include/linux/wireless.h	2008-02-23 14:14:14.000000000 +0100
+++ everything/include/linux/wireless.h	2008-02-23 14:14:26.000000000 +0100
@@ -455,6 +455,7 @@
 #define IW_MODE_REPEAT	4	/* Wireless Repeater (forwarder) */
 #define IW_MODE_SECOND	5	/* Secondary master/repeater (backup) */
 #define IW_MODE_MONITOR	6	/* Passive monitor (listen only) */
+#define IW_MODE_MESH	7	/* Mesh (IEEE 802.11s) network */
 
 /* Statistics flags (bitmask in updated) */
 #define IW_QUAL_QUAL_UPDATED	0x01	/* Value was updated since last read */

-- 

