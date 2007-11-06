Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:44731 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754086AbXKFWNO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2007 17:13:14 -0500
Date: Tue, 6 Nov 2007 22:49:20 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Larry Finger <larry.finger@lwfinger.net>
Subject: [PATCH 7/7] b43/b43legacy: fix my copyright notices
Message-ID: <20071106224920.20f329b3@morte> (sfid-20071106_221322_433120_9EC9E955)
In-Reply-To: <20071106222313.31e9bcd9@morte>
References: <20071106222313.31e9bcd9@morte>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix my copyright notices in b43 and b43legacy.


Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
Cc: Michael Buesch <mb@bu3sch.de>

----

Index: wireless-2.6/drivers/net/wireless/b43/leds.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/leds.c
+++ wireless-2.6/drivers/net/wireless/b43/leds.c
@@ -4,7 +4,7 @@
   LED control
 
   Copyright (c) 2005 Martin Langer <martin-langer@gmx.de>,
-  Copyright (c) 2005 Stefano Brivio <st3@riseup.net>
+  Copyright (c) 2005 Stefano Brivio <stefano.brivio@polimi.it>
   Copyright (c) 2005-2007 Michael Buesch <mb@bu3sch.de>
   Copyright (c) 2005 Danny van Dyk <kugelfang@gentoo.org>
   Copyright (c) 2005 Andreas Jaggi <andreas.jaggi@waterwave.ch>
Index: wireless-2.6/drivers/net/wireless/b43/lo.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/lo.c
+++ wireless-2.6/drivers/net/wireless/b43/lo.c
@@ -5,7 +5,7 @@
   G PHY LO (LocalOscillator) Measuring and Control routines
 
   Copyright (c) 2005 Martin Langer <martin-langer@gmx.de>,
-  Copyright (c) 2005, 2006 Stefano Brivio <st3@riseup.net>
+  Copyright (c) 2005, 2006 Stefano Brivio <stefano.brivio@polimi.it>
   Copyright (c) 2005-2007 Michael Buesch <mb@bu3sch.de>
   Copyright (c) 2005, 2006 Danny van Dyk <kugelfang@gentoo.org>
   Copyright (c) 2005, 2006 Andreas Jaggi <andreas.jaggi@waterwave.ch>
Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c
+++ wireless-2.6/drivers/net/wireless/b43/main.c
@@ -3,7 +3,7 @@
   Broadcom B43 wireless driver
 
   Copyright (c) 2005 Martin Langer <martin-langer@gmx.de>
-  Copyright (c) 2005 Stefano Brivio <st3@riseup.net>
+  Copyright (c) 2005 Stefano Brivio <stefano.brivio@polimi.it>
   Copyright (c) 2005, 2006 Michael Buesch <mb@bu3sch.de>
   Copyright (c) 2005 Danny van Dyk <kugelfang@gentoo.org>
   Copyright (c) 2005 Andreas Jaggi <andreas.jaggi@waterwave.ch>
Index: wireless-2.6/drivers/net/wireless/b43/main.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.h
+++ wireless-2.6/drivers/net/wireless/b43/main.h
@@ -3,7 +3,7 @@
   Broadcom B43 wireless driver
 
   Copyright (c) 2005 Martin Langer <martin-langer@gmx.de>,
-                     Stefano Brivio <st3@riseup.net>
+                     Stefano Brivio <stefano.brivio@polimi.it>
                      Michael Buesch <mb@bu3sch.de>
                      Danny van Dyk <kugelfang@gentoo.org>
                      Andreas Jaggi <andreas.jaggi@waterwave.ch>
Index: wireless-2.6/drivers/net/wireless/b43/phy.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/phy.c
+++ wireless-2.6/drivers/net/wireless/b43/phy.c
@@ -3,7 +3,7 @@
   Broadcom B43 wireless driver
 
   Copyright (c) 2005 Martin Langer <martin-langer@gmx.de>,
-  Copyright (c) 2005, 2006 Stefano Brivio <st3@riseup.net>
+  Copyright (c) 2005-2007 Stefano Brivio <stefano.brivio@polimi.it>
   Copyright (c) 2005, 2006 Michael Buesch <mb@bu3sch.de>
   Copyright (c) 2005, 2006 Danny van Dyk <kugelfang@gentoo.org>
   Copyright (c) 2005, 2006 Andreas Jaggi <andreas.jaggi@waterwave.ch>
Index: wireless-2.6/drivers/net/wireless/b43/tables.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/tables.c
+++ wireless-2.6/drivers/net/wireless/b43/tables.c
@@ -3,7 +3,7 @@
   Broadcom B43 wireless driver
 
   Copyright (c) 2005 Martin Langer <martin-langer@gmx.de>,
-  Copyright (c) 2005 Stefano Brivio <st3@riseup.net>
+  Copyright (c) 2005-2007 Stefano Brivio <stefano.brivio@polimi.it>
   Copyright (c) 2006, 2006 Michael Buesch <mb@bu3sch.de>
   Copyright (c) 2005 Danny van Dyk <kugelfang@gentoo.org>
   Copyright (c) 2005 Andreas Jaggi <andreas.jaggi@waterwave.ch>
Index: wireless-2.6/drivers/net/wireless/b43/wa.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/wa.c
+++ wireless-2.6/drivers/net/wireless/b43/wa.c
@@ -4,11 +4,8 @@
 
   PHY workarounds.
 
-  Copyright (c) 2005 Martin Langer <martin-langer@gmx.de>,
-  Copyright (c) 2005-2007 Stefano Brivio <st3@riseup.net>
+  Copyright (c) 2005-2007 Stefano Brivio <stefano.brivio@polimi.it>
   Copyright (c) 2005-2007 Michael Buesch <mbuesch@freenet.de>
-  Copyright (c) 2005, 2006 Danny van Dyk <kugelfang@gentoo.org>
-  Copyright (c) 2005, 2006 Andreas Jaggi <andreas.jaggi@waterwave.ch>
 
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
Index: wireless-2.6/drivers/net/wireless/b43/xmit.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/xmit.c
+++ wireless-2.6/drivers/net/wireless/b43/xmit.c
@@ -5,7 +5,7 @@
   Transmission (TX/RX) related functions.
 
   Copyright (C) 2005 Martin Langer <martin-langer@gmx.de>
-  Copyright (C) 2005 Stefano Brivio <st3@riseup.net>
+  Copyright (C) 2005 Stefano Brivio <stefano.brivio@polimi.it>
   Copyright (C) 2005, 2006 Michael Buesch <mb@bu3sch.de>
   Copyright (C) 2005 Danny van Dyk <kugelfang@gentoo.org>
   Copyright (C) 2005 Andreas Jaggi <andreas.jaggi@waterwave.ch>
Index: wireless-2.6/drivers/net/wireless/b43legacy/ilt.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/ilt.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/ilt.c
@@ -3,7 +3,7 @@
   Broadcom B43legacy wireless driver
 
   Copyright (c) 2005 Martin Langer <martin-langer@gmx.de>,
-		     Stefano Brivio <st3@riseup.net>
+		     Stefano Brivio <stefano.brivio@polimi.it>
 		     Michael Buesch <mbuesch@freenet.de>
 		     Danny van Dyk <kugelfang@gentoo.org>
 		     Andreas Jaggi <andreas.jaggi@waterwave.ch>
Index: wireless-2.6/drivers/net/wireless/b43legacy/leds.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/leds.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/leds.c
@@ -4,7 +4,7 @@
   LED control
 
   Copyright (c) 2005 Martin Langer <martin-langer@gmx.de>,
-  Copyright (c) 2005 Stefano Brivio <st3@riseup.net>
+  Copyright (c) 2005 Stefano Brivio <stefano.brivio@polimi.it>
   Copyright (c) 2005-2007 Michael Buesch <mb@bu3sch.de>
   Copyright (c) 2005 Danny van Dyk <kugelfang@gentoo.org>
   Copyright (c) 2005 Andreas Jaggi <andreas.jaggi@waterwave.ch>
Index: wireless-2.6/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/main.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/main.c
@@ -3,7 +3,7 @@
  *  Broadcom B43legacy wireless driver
  *
  *  Copyright (c) 2005 Martin Langer <martin-langer@gmx.de>
- *  Copyright (c) 2005 Stefano Brivio <st3@riseup.net>
+ *  Copyright (c) 2005-2007 Stefano Brivio <stefano.brivio@polimi.it>
  *  Copyright (c) 2005, 2006 Michael Buesch <mb@bu3sch.de>
  *  Copyright (c) 2005 Danny van Dyk <kugelfang@gentoo.org>
  *  Copyright (c) 2005 Andreas Jaggi <andreas.jaggi@waterwave.ch>
Index: wireless-2.6/drivers/net/wireless/b43legacy/main.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/main.h
+++ wireless-2.6/drivers/net/wireless/b43legacy/main.h
@@ -3,7 +3,7 @@
   Broadcom B43legacy wireless driver
 
   Copyright (c) 2005 Martin Langer <martin-langer@gmx.de>,
-  Copyright (c) 2005 Stefano Brivio <st3@riseup.net>
+  Copyright (c) 2005 Stefano Brivio <stefano.brivio@polimi.it>
   Copyright (c) 2005, 2006 Michael Buesch <mb@bu3sch.de>
   Copyright (c) 2005  Danny van Dyk <kugelfang@gentoo.org>
   Copyright (c) 2005  Andreas Jaggi <andreas.jaggi@waterwave.ch>
Index: wireless-2.6/drivers/net/wireless/b43legacy/phy.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/phy.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/phy.c
@@ -3,7 +3,7 @@
   Broadcom B43legacy wireless driver
 
   Copyright (c) 2005 Martin Langer <martin-langer@gmx.de>,
-		     Stefano Brivio <st3@riseup.net>
+		     Stefano Brivio <stefano.brivio@polimi.it>
 		     Michael Buesch <mbuesch@freenet.de>
 		     Danny van Dyk <kugelfang@gentoo.org>
      Andreas Jaggi <andreas.jaggi@waterwave.ch>
Index: wireless-2.6/drivers/net/wireless/b43legacy/phy.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/phy.h
+++ wireless-2.6/drivers/net/wireless/b43legacy/phy.h
@@ -3,7 +3,7 @@
   Broadcom B43legacy wireless driver
 
   Copyright (c) 2005 Martin Langer <martin-langer@gmx.de>,
-		     Stefano Brivio <st3@riseup.net>
+		     Stefano Brivio <stefano.brivio@polimi.it>
 		     Michael Buesch <mbuesch@freenet.de>
 		     Danny van Dyk <kugelfang@gentoo.org>
 		     Andreas Jaggi <andreas.jaggi@waterwave.ch>
Index: wireless-2.6/drivers/net/wireless/b43legacy/radio.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/radio.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/radio.c
@@ -3,7 +3,7 @@
   Broadcom B43legacy wireless driver
 
   Copyright (c) 2005 Martin Langer <martin-langer@gmx.de>,
-		     Stefano Brivio <st3@riseup.net>
+		     Stefano Brivio <stefano.brivio@polimi.it>
 		     Michael Buesch <mbuesch@freenet.de>
 		     Danny van Dyk <kugelfang@gentoo.org>
 		     Andreas Jaggi <andreas.jaggi@waterwave.ch>
Index: wireless-2.6/drivers/net/wireless/b43legacy/radio.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/radio.h
+++ wireless-2.6/drivers/net/wireless/b43legacy/radio.h
@@ -3,7 +3,7 @@
   Broadcom B43legacy wireless driver
 
   Copyright (c) 2005 Martin Langer <martin-langer@gmx.de>,
-		     Stefano Brivio <st3@riseup.net>
+		     Stefano Brivio <stefano.brivio@polimi.it>
 		     Michael Buesch <mbuesch@freenet.de>
 		     Danny van Dyk <kugelfang@gentoo.org>
 		     Andreas Jaggi <andreas.jaggi@waterwave.ch>
Index: wireless-2.6/drivers/net/wireless/b43legacy/xmit.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/xmit.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/xmit.c
@@ -5,7 +5,7 @@
   Transmission (TX/RX) related functions.
 
   Copyright (C) 2005 Martin Langer <martin-langer@gmx.de>
-  Copyright (C) 2005 Stefano Brivio <st3@riseup.net>
+  Copyright (C) 2005 Stefano Brivio <stefano.brivio@polimi.it>
   Copyright (C) 2005, 2006 Michael Buesch <mb@bu3sch.de>
   Copyright (C) 2005 Danny van Dyk <kugelfang@gentoo.org>
   Copyright (C) 2005 Andreas Jaggi <andreas.jaggi@waterwave.ch>



-- 
Ciao
Stefano
