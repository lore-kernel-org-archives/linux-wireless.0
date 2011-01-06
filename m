Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58394 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab1AFViF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 16:38:05 -0500
Message-Id: <20110106213715.096887040@sipsolutions.net>
Date: Thu, 06 Jan 2011 22:36:45 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/4] cfg80211: add mesh join/leave callback docs
References: <20110106213643.454994320@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When I made the patch to add mesh join/leave I
didn't pay attention to docs because it was a
proof of concept, and then when we actually did
merge it I forgot -- add docs now.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h |    2 ++
 1 file changed, 2 insertions(+)

--- wireless-testing.orig/include/net/cfg80211.h	2011-01-06 22:20:06.000000000 +0100
+++ wireless-testing/include/net/cfg80211.h	2011-01-06 22:20:41.000000000 +0100
@@ -1103,6 +1103,8 @@ struct cfg80211_pmksa {
  * @change_mpath: change a given mesh path
  * @get_mpath: get a mesh path for the given parameters
  * @dump_mpath: dump mesh path callback -- resume dump at index @idx
+ * @join_mesh: join the mesh network with the specified parameters
+ * @leave_mesh: leave the current mesh network
  *
  * @get_mesh_config: Get the current mesh configuration
  *


