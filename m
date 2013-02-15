Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58920 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab3BOJMZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 04:12:25 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: add correct docbook entries
Date: Fri, 15 Feb 2013 10:12:20 +0100
Message-Id: <1360919540-14691-1-git-send-email-johannes@sipsolutions.net> (sfid-20130215_101236_981116_BD37E708)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Update the 802.11 book to list the correct
data structures.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 Documentation/DocBook/80211.tmpl | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/80211.tmpl b/Documentation/DocBook/80211.tmpl
index 42e7f03..284ced7 100644
--- a/Documentation/DocBook/80211.tmpl
+++ b/Documentation/DocBook/80211.tmpl
@@ -107,8 +107,8 @@
 !Finclude/net/cfg80211.h key_params
 !Finclude/net/cfg80211.h survey_info_flags
 !Finclude/net/cfg80211.h survey_info
-!Finclude/net/cfg80211.h beacon_parameters
-!Finclude/net/cfg80211.h plink_actions
+!Finclude/net/cfg80211.h cfg80211_beacon_data
+!Finclude/net/cfg80211.h cfg80211_ap_settings
 !Finclude/net/cfg80211.h station_parameters
 !Finclude/net/cfg80211.h station_info_flags
 !Finclude/net/cfg80211.h rate_info_flags
-- 
1.8.0

