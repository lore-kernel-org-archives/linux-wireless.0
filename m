Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f12.google.com ([209.85.219.12]:56526 "EHLO
	mail-ew0-f12.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932373AbZAQTtw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Jan 2009 14:49:52 -0500
Received: by ewy5 with SMTP id 5so347330ewy.13
        for <linux-wireless@vger.kernel.org>; Sat, 17 Jan 2009 11:49:49 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: linville@tuxdriver.com
Subject: [PATCH 1/3] rt2x00: Update copyright year to 2009
Date: Sat, 17 Jan 2009 20:42:32 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901172042.32618.IvDoorn@gmail.com> (sfid-20090117_204959_090418_FB056CFB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c      |    2 +-
 drivers/net/wireless/rt2x00/rt2400pci.h      |    2 +-
 drivers/net/wireless/rt2x00/rt2500pci.c      |    2 +-
 drivers/net/wireless/rt2x00/rt2500pci.h      |    2 +-
 drivers/net/wireless/rt2x00/rt2500usb.c      |    2 +-
 drivers/net/wireless/rt2x00/rt2500usb.h      |    2 +-
 drivers/net/wireless/rt2x00/rt2x00.h         |    2 +-
 drivers/net/wireless/rt2x00/rt2x00config.c   |    2 +-
 drivers/net/wireless/rt2x00/rt2x00crypto.c   |    2 +-
 drivers/net/wireless/rt2x00/rt2x00debug.c    |    2 +-
 drivers/net/wireless/rt2x00/rt2x00debug.h    |    2 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c      |    2 +-
 drivers/net/wireless/rt2x00/rt2x00dump.h     |    2 +-
 drivers/net/wireless/rt2x00/rt2x00firmware.c |    2 +-
 drivers/net/wireless/rt2x00/rt2x00leds.c     |    2 +-
 drivers/net/wireless/rt2x00/rt2x00leds.h     |    2 +-
 drivers/net/wireless/rt2x00/rt2x00lib.h      |    2 +-
 drivers/net/wireless/rt2x00/rt2x00link.c     |    2 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c      |    2 +-
 drivers/net/wireless/rt2x00/rt2x00pci.c      |    2 +-
 drivers/net/wireless/rt2x00/rt2x00pci.h      |    2 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c    |    2 +-
 drivers/net/wireless/rt2x00/rt2x00queue.h    |    2 +-
 drivers/net/wireless/rt2x00/rt2x00reg.h      |    2 +-
 drivers/net/wireless/rt2x00/rt2x00rfkill.c   |    2 +-
 drivers/net/wireless/rt2x00/rt2x00usb.c      |    2 +-
 drivers/net/wireless/rt2x00/rt2x00usb.h      |    2 +-
 drivers/net/wireless/rt2x00/rt61pci.c        |    2 +-
 drivers/net/wireless/rt2x00/rt61pci.h        |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.c        |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.h        |    2 +-
 31 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index cd7eff3..bb10a36 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2400pci.h b/drivers/net/wireless/rt2x00/rt2400pci.h
index 9aefda4..72ac31c 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.h
+++ b/drivers/net/wireless/rt2x00/rt2400pci.h
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index bccb082..6f42e10 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.h b/drivers/net/wireless/rt2x00/rt2500pci.h
index e135247..17a0c9c 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.h
+++ b/drivers/net/wireless/rt2x00/rt2500pci.h
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 1e262da..1e33273 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.h b/drivers/net/wireless/rt2x00/rt2500usb.h
index e1f714e..afce0e0 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.h
+++ b/drivers/net/wireless/rt2x00/rt2500usb.h
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 38dd10a..81a1917 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index 8fa57a7..f1f458e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2x00crypto.c b/drivers/net/wireless/rt2x00/rt2x00crypto.c
index f30bda2..938546d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00crypto.c
+++ b/drivers/net/wireless/rt2x00/rt2x00crypto.c
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index cc19406..dcdce7f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.h b/drivers/net/wireless/rt2x00/rt2x00debug.h
index a92104d..035cbc9 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.h
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.h
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 2f80f53..1267b47 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2x00dump.h b/drivers/net/wireless/rt2x00/rt2x00dump.h
index 7169c22..fdedb51 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dump.h
+++ b/drivers/net/wireless/rt2x00/rt2x00dump.h
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2x00firmware.c b/drivers/net/wireless/rt2x00/rt2x00firmware.c
index bab05a5..2a7e8bc 100644
--- a/drivers/net/wireless/rt2x00/rt2x00firmware.c
+++ b/drivers/net/wireless/rt2x00/rt2x00firmware.c
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2x00leds.c b/drivers/net/wireless/rt2x00/rt2x00leds.c
index a0cd35b..9b531e0 100644
--- a/drivers/net/wireless/rt2x00/rt2x00leds.c
+++ b/drivers/net/wireless/rt2x00/rt2x00leds.c
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2x00leds.h b/drivers/net/wireless/rt2x00/rt2x00leds.h
index 9df4a49..1046977 100644
--- a/drivers/net/wireless/rt2x00/rt2x00leds.h
+++ b/drivers/net/wireless/rt2x00/rt2x00leds.h
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index eab57ea..fa067ea 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2x00link.c b/drivers/net/wireless/rt2x00/rt2x00link.c
index ee08f11..9223a6d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00link.c
+++ b/drivers/net/wireless/rt2x00/rt2x00link.c
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 3e20440..71de8a7 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index 5dd48ca..1fec49f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.h b/drivers/net/wireless/rt2x00/rt2x00pci.h
index 9c0a4d7..15a1248 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.h
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.h
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 4e8d4d7..ce06d00 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 8d815df..70cbe8f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2x00reg.h b/drivers/net/wireless/rt2x00/rt2x00reg.h
index 93f8427..9ddc2d0 100644
--- a/drivers/net/wireless/rt2x00/rt2x00reg.h
+++ b/drivers/net/wireless/rt2x00/rt2x00reg.h
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2x00rfkill.c b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
index 0b089ec..55d7774 100644
--- a/drivers/net/wireless/rt2x00/rt2x00rfkill.c
+++ b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 0b29d76..c89d152 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless/rt2x00/rt2x00usb.h
index 2bd4ac8..fe45238 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 498a62c..b07b41f 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt61pci.h b/drivers/net/wireless/rt2x00/rt61pci.h
index cd86def..2f97fee 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.h
+++ b/drivers/net/wireless/rt2x00/rt61pci.h
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index efe851e..d64c7cf 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt73usb.h b/drivers/net/wireless/rt2x00/rt73usb.h
index 204bbd5..834b28c 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.h
+++ b/drivers/net/wireless/rt2x00/rt73usb.h
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
-- 
1.5.6.1

