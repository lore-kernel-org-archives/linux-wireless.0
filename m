Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:45261 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751452AbaEZGaT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 02:30:19 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Date: Mon, 26 May 2014 09:30:12 +0300
Message-Id: <1401085812-21040-1-git-send-email-luca@coelho.fi> (sfid-20140526_083023_239812_0560397F)
Subject: [PATCH] mac80211: docs: remove spurious blank line that causes docbook warnings
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

When making htmldocs (at least) the following warning was being generated:

Warning(/home/luca/kvm-shared/git/public/mac80211-next//include/net/mac80211.h:2770): bad line:

The cause was a stray empty line inside a block of documentation.  Fix this.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 include/net/mac80211.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 38c10ea..e0bde8c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2767,7 +2767,6 @@ enum ieee80211_roc_type {
  *	to vif. Possible use is for hw queue remapping.
  * @unassign_vif_chanctx: Notifies device driver about channel context being
  *	unbound from vif.
-
  * @switch_vif_chanctx: switch a number of vifs from one chanctx to
  *	another, as specified in the list of
  *	@ieee80211_vif_chanctx_switch passed to the driver, according
-- 
2.0.0.rc0

