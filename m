Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:7135 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561AbXJHJnX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Oct 2007 05:43:23 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] libertas: fix a debug statement
Date: Mon, 8 Oct 2007 11:09:30 +0200
Cc: libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200710081109.30541.hs4233@mail.mn-solutions.de> (sfid-20071008_104359_404729_94C68433)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix a debug statement

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: libertas-2.6/drivers/net/wireless/libertas/cmdresp.c
===================================================================
--- libertas-2.6.orig/drivers/net/wireless/libertas/cmdresp.c	
2007-07-12 21:12:16.000000000 +0200
+++ libertas-2.6/drivers/net/wireless/libertas/cmdresp.c	
2007-07-12 21:14:02.000000000 +0200
@@ -148,7 +148,7 @@
 		ret = -1;
 	}
 
-	lbs_deb_enter_args(LBS_DEB_CMD, "ret %d", ret);
+	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
 	return ret;
 }
 
