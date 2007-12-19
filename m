Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:56754 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754595AbXLSAtj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 19:49:39 -0500
Date: Wed, 19 Dec 2007 01:46:53 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] doc: fix typo in feature-removal-schedule
Message-ID: <20071219014653.07378245@morte> (sfid-20071219_004941_888078_0A148EF6)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
---
Index: wireless-2.6/Documentation/feature-removal-schedule.txt
===================================================================
--- wireless-2.6.orig/Documentation/feature-removal-schedule.txt
+++ wireless-2.6/Documentation/feature-removal-schedule.txt
@@ -343,7 +343,7 @@ Who:	John W. Linville <linville@tuxdrive
 
 ---------------------------
 
-What:	iee80211 softmac wireless networking component
+What:	ieee80211 softmac wireless networking component
 When:	2.6.26 (or after removal of bcm43xx and port of zd1211rw to mac80211)
 Files:	net/ieee80211/softmac
 Why:	No in-kernel drivers will depend on it any longer.


--
Ciao
Stefano
