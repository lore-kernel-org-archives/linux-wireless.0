Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp5.pp.htv.fi ([213.243.153.39]:45287 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765098AbYESWMM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2008 18:12:12 -0400
Date: Tue, 20 May 2008 01:10:06 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [2.6 patch] strip: remove dead URL
Message-ID: <20080519221006.GZ17716@cs181133002.pp.htv.fi> (sfid-20080520_001225_773681_C22DD3EF)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

http://mosquitonet.Stanford.EDU/strip.html no longer exists.

Since the MAINTAINERS entry is now completely empty it's also removed.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 MAINTAINERS                  |    4 ----
 drivers/net/wireless/Kconfig |   15 ++++++++-------
 2 files changed, 8 insertions(+), 11 deletions(-)

e85bb123fa985f107ac04b8f7150b3bc6909e723 diff --git a/MAINTAINERS b/MAINTAINERS
index 8c2db8c..018f40d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3836,10 +3836,6 @@ P:	Ion Badulescu
 M:	ionut@cs.columbia.edu
 S:	Maintained
 
-STARMODE RADIO IP (STRIP) PROTOCOL DRIVER
-W:	http://mosquitonet.Stanford.EDU/strip.html
-S:	Unsupported ?
-
 STRADIS MPEG-2 DECODER DRIVER
 P:	Nathan Laredo
 M:	laredo@gnu.org
diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index fdf5aa8..65b6322 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -21,13 +21,14 @@ config STRIP
 	---help---
 	  Say Y if you have a Metricom radio and intend to use Starmode Radio
 	  IP. STRIP is a radio protocol developed for the MosquitoNet project
-	  (on the WWW at <http://mosquitonet.stanford.edu/>) to send Internet
-	  traffic using Metricom radios.  Metricom radios are small, battery
-	  powered, 100kbit/sec packet radio transceivers, about the size and
-	  weight of a cellular telephone. (You may also have heard them called
-	  "Metricom modems" but we avoid the term "modem" because it misleads
-	  many people into thinking that you can plug a Metricom modem into a
-	  phone line and use it as a modem.)
+	  to send Internet traffic using Metricom radios.
+
+	  Metricom radios are small, battery powered, 100kbit/sec packet radio
+	  transceivers, about the size and weight of a cellular telephone.
+	  (You may also have heard them called "Metricom modems" but we avoid
+	  the term "modem" because it misleads many people into thinking that
+	  you can plug a Metricom modem into a phone line and use it as
+	  a modem.)
 
 	  You can use STRIP on any Linux machine with a serial port, although
 	  it is obviously most useful for people with laptop computers. If you

