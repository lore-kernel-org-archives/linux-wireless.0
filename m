Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:54915 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089AbZDRNex (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Apr 2009 09:34:53 -0400
Date: Sat, 18 Apr 2009 09:33:55 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
To: linux-wireless@vger.kernel.org
cc: johannes@sipsolutions.net
Subject: [PATCH] MAC80211: Remove unused MAC80211_VERBOSE_SPECT_MGMT_DEBUG.
Message-ID: <alpine.LFD.2.00.0904180930530.3509@localhost.localdomain> (sfid-20090418_153455_297187_689EB367)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Remove this unused Kconfig variable, which Intel apparently once
promised to make use of but never did.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index f3d9ae3..ecc3faf 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -202,10 +202,3 @@ config MAC80211_DEBUG_COUNTERS
 	  and show them in debugfs.

 	  If unsure, say N.
-
-config MAC80211_VERBOSE_SPECT_MGMT_DEBUG
-	bool "Verbose Spectrum Management (IEEE 802.11h)debugging"
-	depends on MAC80211_DEBUG_MENU
-	---help---
-	  Say Y here to print out verbose Spectrum Management (IEEE 802.11h)
-	  debug messages.

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
