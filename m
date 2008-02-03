Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.176]:12566 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761782AbYBCOqm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Feb 2008 09:46:42 -0500
Received: by py-out-1112.google.com with SMTP id u52so2703745pyb.10
        for <linux-wireless@vger.kernel.org>; Sun, 03 Feb 2008 06:46:41 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 01/19] rt2x00: Update copyright notice
Date: Sun, 3 Feb 2008 15:42:53 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802031541.52167.IvDoorn@gmail.com>
In-Reply-To: <200802031541.52167.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802031542.53511.IvDoorn@gmail.com> (sfid-20080203_144646_609668_11F618FA)
From: Ivo van Doorn <ivdoorn@gmail.com>
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
 drivers/net/wireless/rt2x00/rt2x00debug.c    |    2 +-
 drivers/net/wireless/rt2x00/rt2x00debug.h    |    2 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c      |    2 +-
 drivers/net/wireless/rt2x00/rt2x00dump.h     |    2 +-
 drivers/net/wireless/rt2x00/rt2x00firmware.c |    2 +-
 drivers/net/wireless/rt2x00/rt2x00lib.h      |    2 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c      |    2 +-
 drivers/net/wireless/rt2x00/rt2x00pci.c      |    2 +-
 drivers/net/wireless/rt2x00/rt2x00pci.h      |    2 +-
 drivers/net/wireless/rt2x00/rt2x00reg.h      |    2 +-
 drivers/net/wireless/rt2x00/rt2x00rfkill.c   |    2 +-
 drivers/net/wireless/rt2x00/rt2x00ring.h     |    2 +-
 drivers/net/wireless/rt2x00/rt2x00usb.c      |    2 +-
 drivers/net/wireless/rt2x00/rt2x00usb.h      |    2 +-
 drivers/net/wireless/rt2x00/rt61pci.c        |    2 +-
 drivers/net/wireless/rt2x00/rt61pci.h        |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.c        |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.h        |    2 +-
 26 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index d6cba13..406f589 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2007 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2400pci.h b/drivers/net/wireless/rt2x00/rt2400pci.h
index 369aac6..3d59d66 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.h
+++ b/drivers/net/wireless/rt2x00/rt2400pci.h
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2007 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index e874fdc..0436e4a 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2007 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.h b/drivers/net/wireless/rt2x00/rt2500pci.h
index 92ba090..0af130c 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.h
+++ b/drivers/net/wireless/rt2x00/rt2500pci.h
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2007 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 86ded40..4753424 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2007 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.h b/drivers/net/wireless/rt2x00/rt2500usb.h
index 9e04337..e9f2cd9 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.h
+++ b/drivers/net/wireless/rt2x00/rt2500usb.h
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2007 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 6847585..dc4ae56 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2007 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index 9e5bfce..0ebdf81 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2007 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index b44a9f4..d70ce6e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2007 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.h b/drivers/net/wireless/rt2x00/rt2x00debug.h
index d37efbd..c4ce895 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.h
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.h
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2007 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index d5e4512..628cfb9 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2007 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2x00dump.h b/drivers/net/wireless/rt2x00/rt2x00dump.h
index 99f3f36..93f8967 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dump.h
+++ b/drivers/net/wireless/rt2x00/rt2x00dump.h
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2007 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2x00firmware.c b/drivers/net/wireless/rt2x00/rt2x00firmware.c
index 0a475e4..442ff80 100644
--- a/drivers/net/wireless/rt2x00/rt2x00firmware.c
+++ b/drivers/net/wireless/rt2x00/rt2x00firmware.c
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2007 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 1adbd28..7540d29 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2007 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index e3f15e5..e638c65 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2007 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index b76c130..6df4a3e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2007 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.h b/drivers/net/wireless/rt2x00/rt2x00pci.h
index 2d1eb81..9ac560b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.h
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.h
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2007 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2x00reg.h b/drivers/net/wireless/rt2x00/rt2x00reg.h
index 8384212..04e4799 100644
--- a/drivers/net/wireless/rt2x00/rt2x00reg.h
+++ b/drivers/net/wireless/rt2x00/rt2x00reg.h
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2007 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2x00rfkill.c b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
index 34a96d4..6712142 100644
--- a/drivers/net/wireless/rt2x00/rt2x00rfkill.c
+++ b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2007 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2x00ring.h b/drivers/net/wireless/rt2x00/rt2x00ring.h
index 1caa6d6..764c255 100644
--- a/drivers/net/wireless/rt2x00/rt2x00ring.h
+++ b/drivers/net/wireless/rt2x00/rt2x00ring.h
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2007 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index dc7695c..e566acc 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2007 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless/rt2x00/rt2x00usb.h
index e40df40..b5c1d17 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2007 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 5f97217..b3044cf 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2007 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt61pci.h b/drivers/net/wireless/rt2x00/rt61pci.h
index 4c6524e..e4578fb 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.h
+++ b/drivers/net/wireless/rt2x00/rt61pci.h
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2007 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index e2d9dcc..2f0d7e2 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2007 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/rt2x00/rt73usb.h b/drivers/net/wireless/rt2x00/rt73usb.h
index d49dcaa..bc63590 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.h
+++ b/drivers/net/wireless/rt2x00/rt73usb.h
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2007 rt2x00 SourceForge Project
+	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
-- 
1.5.3.8

