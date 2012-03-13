Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hhlx01.vscom.de ([62.145.30.242]:55641 "EHLO
	mail.visionsystems.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756167Ab2CMJ6P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Mar 2012 05:58:15 -0400
From: yegorslists@googlemail.com
To: linux-wireless@vger.kernel.org
Cc: johannes.berg@intel.com,
	Yegor Yefremov <yegorslists@googlemail.com>
Subject: [PATCH] Documentation: make exists consistent
Date: Tue, 13 Mar 2012 10:57:51 +0100
Message-Id: <1331632671-2102-1-git-send-email-yegorslists@googlemail.com> (sfid-20120313_105818_902695_52F6FDF0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yegor Yefremov <yegorslists@googlemail.com>

Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
---
 .../networking/mac80211-auth-assoc-deauth.txt      |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/mac80211-auth-assoc-deauth.txt b/Documentation/networking/mac80211-auth-assoc-deauth.txt
index 721773d..e0a2aa58 100644
--- a/Documentation/networking/mac80211-auth-assoc-deauth.txt
+++ b/Documentation/networking/mac80211-auth-assoc-deauth.txt
@@ -14,7 +14,7 @@ alt authentication needed (not FT)
 userspace->mac80211: authenticate
 
 alt authenticated/authenticating already
-mac80211->driver: sta_state(AP, not-exist)
+mac80211->driver: sta_state(AP, not-exists)
 mac80211->driver: bss_info_changed(clear BSSID)
 else associated
 note over mac80211,driver
@@ -91,8 +91,8 @@ mac80211->driver: TX deauth/disassoc
 mac80211->driver: flush frames
 mac80211->driver: sta_state(AP,associated)
 mac80211->driver: sta_state(AP,authenticated)
-mac80211->driver: sta_state(AP,exist)
-mac80211->driver: sta_state(AP,not-exist)
+mac80211->driver: sta_state(AP,exists)
+mac80211->driver: sta_state(AP,not-exists)
 mac80211->driver: turn off powersave
 mac80211->driver: bss_info_changed(clear BSSID, not associated, no QoS, ...)
 mac80211->driver: config(non-HT channel type)
-- 
1.7.7

