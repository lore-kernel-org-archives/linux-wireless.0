Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:44731 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753268AbXKFWM5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2007 17:12:57 -0500
Date: Tue, 6 Nov 2007 22:48:56 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: John Linville <linville@tuxdriver.com>,
	Larry Finger <larry.finger@lwfinger.net>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH 5/7] b43legacy: add me as maintainer and fix URLs
Message-ID: <20071106224856.4dbc5d4f@morte> (sfid-20071106_221304_881100_88AF26E5)
In-Reply-To: <20071106222313.31e9bcd9@morte>
References: <20071106222313.31e9bcd9@morte>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As b43legacy is going to be orphaned, add me as a maintainer. Fix URLs for
the related website and fix my e-mail address in MAINTAINERS file.


Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
Cc: Larry Finger <larry.finger@lwfinger.net>

----

Index: wireless-2.6/MAINTAINERS
===================================================================
--- wireless-2.6.orig/MAINTAINERS
+++ wireless-2.6/MAINTAINERS
@@ -798,23 +798,25 @@ B43 WIRELESS DRIVER
 P:	Michael Buesch
 M:	mb@bu3sch.de
 P:	Stefano Brivio
-M:	st3@riseup.net
+M:	stefano.brivio@polimi.it
 L:	linux-wireless@vger.kernel.org
-W:	http://bcm43xx.berlios.de/
+W:	http://linuxwireless.org/en/users/Drivers/b43
 S:	Maintained
 
 B43LEGACY WIRELESS DRIVER
 P:	Larry Finger
 M:	Larry.Finger@lwfinger.net
+P:	Stefano Brivio
+M:	stefano.brivio@polimi.it
 L:	linux-wireless@vger.kernel.org
-W:	http://bcm43xx.berlios.de/
+W:	http://linuxwireless.org/en/users/Drivers/b43
 S:	Maintained
 
 BCM43XX WIRELESS DRIVER (SOFTMAC BASED VERSION)
 P:	Larry Finger
 M:	Larry.Finger@lwfinger.net
 P:	Stefano Brivio
-M:	st3@riseup.net
+M:	stefano.brivio@polimi.it
 L:	linux-wireless@vger.kernel.org
 W:	http://bcm43xx.berlios.de/
 S:	Maintained



-- 
Ciao
Stefano
