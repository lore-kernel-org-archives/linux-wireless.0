Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:44792 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754959Ab2DTP4X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Apr 2012 11:56:23 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/1] mac80211: declare ieee80211_ave_rssi as EXPORT
Date: Fri, 20 Apr 2012 08:51:37 -0700
Message-Id: <1334937097-9383-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120420_175627_811664_5447D98C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_ave_rssi need to be declare as export for driver to use it.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 net/mac80211/util.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 89c1e5b..c42c49c 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1801,3 +1801,4 @@ int ieee80211_ave_rssi(struct ieee80211_vif *vif)
 
 	return ifmgd->ave_beacon_signal;
 }
+EXPORT_SYMBOL_GPL(ieee80211_ave_rssi);
-- 
1.7.0.4

