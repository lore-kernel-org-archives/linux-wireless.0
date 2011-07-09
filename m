Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55443 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab1GIMtS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jul 2011 08:49:18 -0400
Message-Id: <20110709124855.112992920@sipsolutions.net> (sfid-20110709_144929_919505_54E23228)
Date: Sat, 09 Jul 2011 14:48:31 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/2] mac80211: fix docbook
References: <20110709124829.025946360@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

I changed the TKIP key functions, but forgot to
update the documentation includes, fix that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 Documentation/DocBook/80211.tmpl |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/Documentation/DocBook/80211.tmpl	2011-07-09 14:45:55.000000000 +0200
+++ b/Documentation/DocBook/80211.tmpl	2011-07-09 14:46:17.000000000 +0200
@@ -419,8 +419,9 @@ MISSING
 !Finclude/net/mac80211.h set_key_cmd
 !Finclude/net/mac80211.h ieee80211_key_conf
 !Finclude/net/mac80211.h ieee80211_key_flags
-!Finclude/net/mac80211.h ieee80211_tkip_key_type
-!Finclude/net/mac80211.h ieee80211_get_tkip_key
+!Finclude/net/mac80211.h ieee80211_get_tkip_p1k
+!Finclude/net/mac80211.h ieee80211_get_tkip_p1k_iv
+!Finclude/net/mac80211.h ieee80211_get_tkip_p2k
 !Finclude/net/mac80211.h ieee80211_key_removed
       </chapter>
 


