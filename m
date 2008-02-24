Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:51612 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbYBXNnf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Feb 2008 08:43:35 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43legacy: Fix nondebug build
Date: Sun, 24 Feb 2008 14:42:29 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>,
	"R. Hofmann" <anmue@gmx.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200802241442.29497.mb@bu3sch.de> (sfid-20080224_134340_920706_DCCD5C60)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix a typo.

Signed-off-by: Michael Buesch <mb@bu3sch.de>


Index: wireless-testing/drivers/net/wireless/b43legacy/b43legacy.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/b43legacy.h	2008-02-24 14:23:51.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43legacy/b43legacy.h	2008-02-24 14:40:25.000000000 +0100
@@ -343,7 +343,7 @@ enum {
 #else
 /* This will evaluate the argument even if debugging is disabled. */
 static inline bool __b43legacy_warn_on_dummy(bool x) { return x; }
-# define B43_WARN_ON(x)	__b43legacy_warn_on_dummy(unlikely(!!(x)))
+# define B43legacy_WARN_ON(x)	__b43legacy_warn_on_dummy(unlikely(!!(x)))
 # define B43legacy_BUG_ON(x)	do { /* nothing */ } while (0)
 # define B43legacy_DEBUG	0
 #endif

-- 
Greetings Michael.
