Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:41515 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab1ICS6u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Sep 2011 14:58:50 -0400
Received: by gwaa12 with SMTP id a12so2288478gwa.19
        for <linux-wireless@vger.kernel.org>; Sat, 03 Sep 2011 11:58:49 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/3] b43: add my copyrights and myself as the module author
Date: Sat,  3 Sep 2011 21:01:02 +0200
Message-Id: <1315076463-11222-3-git-send-email-zajec5@gmail.com> (sfid-20110903_205852_469510_5977B28B)
In-Reply-To: <1315076463-11222-1-git-send-email-zajec5@gmail.com>
References: <1315076463-11222-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/bus.c            |    2 ++
 drivers/net/wireless/b43/main.c           |    2 ++
 drivers/net/wireless/b43/phy_ht.c         |    2 ++
 drivers/net/wireless/b43/phy_lcn.c        |    2 ++
 drivers/net/wireless/b43/phy_n.c          |    1 +
 drivers/net/wireless/b43/radio_2055.c     |    1 +
 drivers/net/wireless/b43/radio_2056.c     |    2 ++
 drivers/net/wireless/b43/radio_2059.c     |    2 ++
 drivers/net/wireless/b43/tables_nphy.c    |    1 +
 drivers/net/wireless/b43/tables_phy_ht.c  |    2 ++
 drivers/net/wireless/b43/tables_phy_lcn.c |    2 ++
 11 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/bus.c b/drivers/net/wireless/b43/bus.c
index 05f6c7b..424692d 100644
--- a/drivers/net/wireless/b43/bus.c
+++ b/drivers/net/wireless/b43/bus.c
@@ -3,6 +3,8 @@
   Broadcom B43 wireless driver
   Bus abstraction layer
 
+  Copyright (c) 2011 Rafał Miłecki <zajec5@gmail.com>
+
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 6bca727..2407702 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -7,6 +7,7 @@
   Copyright (c) 2005-2009 Michael Buesch <m@bues.ch>
   Copyright (c) 2005 Danny van Dyk <kugelfang@gentoo.org>
   Copyright (c) 2005 Andreas Jaggi <andreas.jaggi@waterwave.ch>
+  Copyright (c) 2010-2011 Rafał Miłecki <zajec5@gmail.com>
 
   SDIO support
   Copyright (c) 2009 Albert Herranz <albert_herranz@yahoo.es>
@@ -64,6 +65,7 @@ MODULE_AUTHOR("Martin Langer");
 MODULE_AUTHOR("Stefano Brivio");
 MODULE_AUTHOR("Michael Buesch");
 MODULE_AUTHOR("Gábor Stefanik");
+MODULE_AUTHOR("Rafał Miłecki");
 MODULE_LICENSE("GPL");
 
 MODULE_FIRMWARE("b43/ucode11.fw");
diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index 4d6345e..7416c5e 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -3,6 +3,8 @@
   Broadcom B43 wireless driver
   IEEE 802.11n HT-PHY support
 
+  Copyright (c) 2011 Rafał Miłecki <zajec5@gmail.com>
+
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
diff --git a/drivers/net/wireless/b43/phy_lcn.c b/drivers/net/wireless/b43/phy_lcn.c
index d0f106e..d1dfeec 100644
--- a/drivers/net/wireless/b43/phy_lcn.c
+++ b/drivers/net/wireless/b43/phy_lcn.c
@@ -3,6 +3,8 @@
   Broadcom B43 wireless driver
   IEEE 802.11n LCN-PHY support
 
+  Copyright (c) 2011 Rafał Miłecki <zajec5@gmail.com>
+
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 6e91680..4951678 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -4,6 +4,7 @@
   IEEE 802.11n PHY support
 
   Copyright (c) 2008 Michael Buesch <m@bues.ch>
+  Copyright (c) 2010-2011 Rafał Miłecki <zajec5@gmail.com>
 
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
diff --git a/drivers/net/wireless/b43/radio_2055.c b/drivers/net/wireless/b43/radio_2055.c
index 93643f1..5289a18 100644
--- a/drivers/net/wireless/b43/radio_2055.c
+++ b/drivers/net/wireless/b43/radio_2055.c
@@ -4,6 +4,7 @@
   IEEE 802.11n PHY and radio device data tables
 
   Copyright (c) 2008 Michael Buesch <m@bues.ch>
+  Copyright (c) 2010 Rafał Miłecki <zajec5@gmail.com>
 
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
diff --git a/drivers/net/wireless/b43/radio_2056.c b/drivers/net/wireless/b43/radio_2056.c
index 8890df0..a01f776 100644
--- a/drivers/net/wireless/b43/radio_2056.c
+++ b/drivers/net/wireless/b43/radio_2056.c
@@ -3,6 +3,8 @@
   Broadcom B43 wireless driver
   IEEE 802.11n 2056 radio device data tables
 
+  Copyright (c) 2010 Rafał Miłecki <zajec5@gmail.com>
+
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
diff --git a/drivers/net/wireless/b43/radio_2059.c b/drivers/net/wireless/b43/radio_2059.c
index f029f6e..d4ce8a1 100644
--- a/drivers/net/wireless/b43/radio_2059.c
+++ b/drivers/net/wireless/b43/radio_2059.c
@@ -3,6 +3,8 @@
   Broadcom B43 wireless driver
   IEEE 802.11n 2059 radio device data tables
 
+  Copyright (c) 2011 Rafał Miłecki <zajec5@gmail.com>
+
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index 916f238..7b326f2 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -4,6 +4,7 @@
   IEEE 802.11n PHY data tables
 
   Copyright (c) 2008 Michael Buesch <m@bues.ch>
+  Copyright (c) 2010 Rafał Miłecki <zajec5@gmail.com>
 
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
diff --git a/drivers/net/wireless/b43/tables_phy_ht.c b/drivers/net/wireless/b43/tables_phy_ht.c
index 677d217..176c49d 100644
--- a/drivers/net/wireless/b43/tables_phy_ht.c
+++ b/drivers/net/wireless/b43/tables_phy_ht.c
@@ -3,6 +3,8 @@
   Broadcom B43 wireless driver
   IEEE 802.11n HT-PHY data tables
 
+  Copyright (c) 2011 Rafał Miłecki <zajec5@gmail.com>
+
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
diff --git a/drivers/net/wireless/b43/tables_phy_lcn.c b/drivers/net/wireless/b43/tables_phy_lcn.c
index 7bf7057..1682ba0 100644
--- a/drivers/net/wireless/b43/tables_phy_lcn.c
+++ b/drivers/net/wireless/b43/tables_phy_lcn.c
@@ -3,6 +3,8 @@
   Broadcom B43 wireless driver
   IEEE 802.11n LCN-PHY data tables
 
+  Copyright (c) 2011 Rafał Miłecki <zajec5@gmail.com>
+
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
-- 
1.7.3.4

