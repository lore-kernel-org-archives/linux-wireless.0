Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:33590 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab0HVTq6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Aug 2010 15:46:58 -0400
Received: from saunalahti-vams (vs3-12.mail.saunalahti.fi [62.142.5.96])
	by emh06-2.mail.saunalahti.fi (Postfix) with SMTP id 424B6C8079
	for <linux-wireless@vger.kernel.org>; Sun, 22 Aug 2010 22:46:56 +0300 (EEST)
Received: from potku.valot.fi (a85-156-250-252.elisa-laajakaista.fi [85.156.250.252])
	by emh04.mail.saunalahti.fi (Postfix) with ESMTP id 45F5B41BE2
	for <linux-wireless@vger.kernel.org>; Sun, 22 Aug 2010 22:46:49 +0300 (EEST)
Subject: [PATCH 3/4] wl1251: remove copyright contact person
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@adurom.com>
Date: Sun, 22 Aug 2010 22:46:43 +0300
Message-ID: <20100822194643.16660.75071.stgit@potku.valot.fi>
In-Reply-To: <20100822194615.16660.21195.stgit@potku.valot.fi>
References: <20100822194615.16660.21195.stgit@potku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As my nokia address doesn't work anymore, it's better just to remove the
copyright contact altogether. We have MODULE_AUTHOR() scripts for these
anyway.

Signed-off-by: Kalle Valo <kvalo@adurom.com>
---
 drivers/net/wireless/wl12xx/wl1251.h         |    2 --
 drivers/net/wireless/wl12xx/wl1251_acx.h     |    2 --
 drivers/net/wireless/wl12xx/wl1251_boot.c    |    2 --
 drivers/net/wireless/wl12xx/wl1251_boot.h    |    2 --
 drivers/net/wireless/wl12xx/wl1251_cmd.h     |    2 --
 drivers/net/wireless/wl12xx/wl1251_debugfs.c |    2 --
 drivers/net/wireless/wl12xx/wl1251_debugfs.h |    2 --
 drivers/net/wireless/wl12xx/wl1251_event.c   |    2 --
 drivers/net/wireless/wl12xx/wl1251_event.h   |    2 --
 drivers/net/wireless/wl12xx/wl1251_init.c    |    2 --
 drivers/net/wireless/wl12xx/wl1251_init.h    |    2 --
 drivers/net/wireless/wl12xx/wl1251_io.c      |    2 --
 drivers/net/wireless/wl12xx/wl1251_main.c    |    2 --
 drivers/net/wireless/wl12xx/wl1251_ps.c      |    2 --
 drivers/net/wireless/wl12xx/wl1251_ps.h      |    2 --
 drivers/net/wireless/wl12xx/wl1251_reg.h     |    2 --
 drivers/net/wireless/wl12xx/wl1251_rx.c      |    2 --
 drivers/net/wireless/wl12xx/wl1251_rx.h      |    2 --
 drivers/net/wireless/wl12xx/wl1251_spi.c     |    2 --
 drivers/net/wireless/wl12xx/wl1251_spi.h     |    2 --
 drivers/net/wireless/wl12xx/wl1251_tx.c      |    2 --
 drivers/net/wireless/wl12xx/wl1251_tx.h      |    2 --
 22 files changed, 0 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251.h b/drivers/net/wireless/wl12xx/wl1251.h
index 6b942a2..9bc4fea 100644
--- a/drivers/net/wireless/wl12xx/wl1251.h
+++ b/drivers/net/wireless/wl12xx/wl1251.h
@@ -4,8 +4,6 @@
  * Copyright (c) 1998-2007 Texas Instruments Incorporated
  * Copyright (C) 2008-2009 Nokia Corporation
  *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * version 2 as published by the Free Software Foundation.
diff --git a/drivers/net/wireless/wl12xx/wl1251_acx.h b/drivers/net/wireless/wl12xx/wl1251_acx.h
index a8845b8..c7cc5c1 100644
--- a/drivers/net/wireless/wl12xx/wl1251_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1251_acx.h
@@ -4,8 +4,6 @@
  * Copyright (c) 1998-2007 Texas Instruments Incorporated
  * Copyright (C) 2008 Nokia Corporation
  *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * version 2 as published by the Free Software Foundation.
diff --git a/drivers/net/wireless/wl12xx/wl1251_boot.c b/drivers/net/wireless/wl12xx/wl1251_boot.c
index 5e65f47..468b47b 100644
--- a/drivers/net/wireless/wl12xx/wl1251_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1251_boot.c
@@ -3,8 +3,6 @@
  *
  * Copyright (C) 2008 Nokia Corporation
  *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * version 2 as published by the Free Software Foundation.
diff --git a/drivers/net/wireless/wl12xx/wl1251_boot.h b/drivers/net/wireless/wl12xx/wl1251_boot.h
index 9006369..7661bc5 100644
--- a/drivers/net/wireless/wl12xx/wl1251_boot.h
+++ b/drivers/net/wireless/wl12xx/wl1251_boot.h
@@ -3,8 +3,6 @@
  *
  * Copyright (C) 2008 Nokia Corporation
  *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * version 2 as published by the Free Software Foundation.
diff --git a/drivers/net/wireless/wl12xx/wl1251_cmd.h b/drivers/net/wireless/wl12xx/wl1251_cmd.h
index 60d7e52..e5c74c6 100644
--- a/drivers/net/wireless/wl12xx/wl1251_cmd.h
+++ b/drivers/net/wireless/wl12xx/wl1251_cmd.h
@@ -4,8 +4,6 @@
  * Copyright (c) 1998-2007 Texas Instruments Incorporated
  * Copyright (C) 2008 Nokia Corporation
  *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * version 2 as published by the Free Software Foundation.
diff --git a/drivers/net/wireless/wl12xx/wl1251_debugfs.c b/drivers/net/wireless/wl12xx/wl1251_debugfs.c
index 5e4465a..6ffe4cd 100644
--- a/drivers/net/wireless/wl12xx/wl1251_debugfs.c
+++ b/drivers/net/wireless/wl12xx/wl1251_debugfs.c
@@ -3,8 +3,6 @@
  *
  * Copyright (C) 2009 Nokia Corporation
  *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * version 2 as published by the Free Software Foundation.
diff --git a/drivers/net/wireless/wl12xx/wl1251_debugfs.h b/drivers/net/wireless/wl12xx/wl1251_debugfs.h
index 6dc3d08..b3417c0 100644
--- a/drivers/net/wireless/wl12xx/wl1251_debugfs.h
+++ b/drivers/net/wireless/wl12xx/wl1251_debugfs.h
@@ -3,8 +3,6 @@
  *
  * Copyright (C) 2009 Nokia Corporation
  *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * version 2 as published by the Free Software Foundation.
diff --git a/drivers/net/wireless/wl12xx/wl1251_event.c b/drivers/net/wireless/wl12xx/wl1251_event.c
index e093a1c..00c3e64 100644
--- a/drivers/net/wireless/wl12xx/wl1251_event.c
+++ b/drivers/net/wireless/wl12xx/wl1251_event.c
@@ -4,8 +4,6 @@
  * Copyright (c) 1998-2007 Texas Instruments Incorporated
  * Copyright (C) 2008 Nokia Corporation
  *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * version 2 as published by the Free Software Foundation.
diff --git a/drivers/net/wireless/wl12xx/wl1251_event.h b/drivers/net/wireless/wl12xx/wl1251_event.h
index ec45647..30eb5d1 100644
--- a/drivers/net/wireless/wl12xx/wl1251_event.h
+++ b/drivers/net/wireless/wl12xx/wl1251_event.h
@@ -4,8 +4,6 @@
  * Copyright (c) 1998-2007 Texas Instruments Incorporated
  * Copyright (C) 2008 Nokia Corporation
  *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * version 2 as published by the Free Software Foundation.
diff --git a/drivers/net/wireless/wl12xx/wl1251_init.c b/drivers/net/wireless/wl12xx/wl1251_init.c
index b538bdd..c5daec0 100644
--- a/drivers/net/wireless/wl12xx/wl1251_init.c
+++ b/drivers/net/wireless/wl12xx/wl1251_init.c
@@ -3,8 +3,6 @@
  *
  * Copyright (C) 2009 Nokia Corporation
  *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * version 2 as published by the Free Software Foundation.
diff --git a/drivers/net/wireless/wl12xx/wl1251_init.h b/drivers/net/wireless/wl12xx/wl1251_init.h
index 269cefb..543f175 100644
--- a/drivers/net/wireless/wl12xx/wl1251_init.h
+++ b/drivers/net/wireless/wl12xx/wl1251_init.h
@@ -3,8 +3,6 @@
  *
  * Copyright (C) 2009 Nokia Corporation
  *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * version 2 as published by the Free Software Foundation.
diff --git a/drivers/net/wireless/wl12xx/wl1251_io.c b/drivers/net/wireless/wl12xx/wl1251_io.c
index f1c232e..ad6ca68 100644
--- a/drivers/net/wireless/wl12xx/wl1251_io.c
+++ b/drivers/net/wireless/wl12xx/wl1251_io.c
@@ -3,8 +3,6 @@
  *
  * Copyright (C) 2008 Nokia Corporation
  *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * version 2 as published by the Free Software Foundation.
diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index c7cffba..edd4845 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -3,8 +3,6 @@
  *
  * Copyright (C) 2008-2009 Nokia Corporation
  *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * version 2 as published by the Free Software Foundation.
diff --git a/drivers/net/wireless/wl12xx/wl1251_ps.c b/drivers/net/wireless/wl12xx/wl1251_ps.c
index b55cb2b..0b997bd 100644
--- a/drivers/net/wireless/wl12xx/wl1251_ps.c
+++ b/drivers/net/wireless/wl12xx/wl1251_ps.c
@@ -3,8 +3,6 @@
  *
  * Copyright (C) 2008 Nokia Corporation
  *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * version 2 as published by the Free Software Foundation.
diff --git a/drivers/net/wireless/wl12xx/wl1251_ps.h b/drivers/net/wireless/wl12xx/wl1251_ps.h
index c688ac5..98ed6c2 100644
--- a/drivers/net/wireless/wl12xx/wl1251_ps.h
+++ b/drivers/net/wireless/wl12xx/wl1251_ps.h
@@ -7,8 +7,6 @@
  * Copyright (c) 1998-2007 Texas Instruments Incorporated
  * Copyright (C) 2008 Nokia Corporation
  *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * version 2 as published by the Free Software Foundation.
diff --git a/drivers/net/wireless/wl12xx/wl1251_reg.h b/drivers/net/wireless/wl12xx/wl1251_reg.h
index d16edd9..a580901 100644
--- a/drivers/net/wireless/wl12xx/wl1251_reg.h
+++ b/drivers/net/wireless/wl12xx/wl1251_reg.h
@@ -4,8 +4,6 @@
  * Copyright (c) 1998-2007 Texas Instruments Incorporated
  * Copyright (C) 2008 Nokia Corporation
  *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * version 2 as published by the Free Software Foundation.
diff --git a/drivers/net/wireless/wl12xx/wl1251_rx.c b/drivers/net/wireless/wl12xx/wl1251_rx.c
index 1b6294b..2576459 100644
--- a/drivers/net/wireless/wl12xx/wl1251_rx.c
+++ b/drivers/net/wireless/wl12xx/wl1251_rx.c
@@ -4,8 +4,6 @@
  * Copyright (c) 1998-2007 Texas Instruments Incorporated
  * Copyright (C) 2008 Nokia Corporation
  *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * version 2 as published by the Free Software Foundation.
diff --git a/drivers/net/wireless/wl12xx/wl1251_rx.h b/drivers/net/wireless/wl12xx/wl1251_rx.h
index da4e534..4448f63 100644
--- a/drivers/net/wireless/wl12xx/wl1251_rx.h
+++ b/drivers/net/wireless/wl12xx/wl1251_rx.h
@@ -4,8 +4,6 @@
  * Copyright (c) 1998-2007 Texas Instruments Incorporated
  * Copyright (C) 2008 Nokia Corporation
  *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * version 2 as published by the Free Software Foundation.
diff --git a/drivers/net/wireless/wl12xx/wl1251_spi.c b/drivers/net/wireless/wl12xx/wl1251_spi.c
index a6435fb..334ded9 100644
--- a/drivers/net/wireless/wl12xx/wl1251_spi.c
+++ b/drivers/net/wireless/wl12xx/wl1251_spi.c
@@ -3,8 +3,6 @@
  *
  * Copyright (C) 2008 Nokia Corporation
  *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * version 2 as published by the Free Software Foundation.
diff --git a/drivers/net/wireless/wl12xx/wl1251_spi.h b/drivers/net/wireless/wl12xx/wl1251_spi.h
index 2e273a9..7dcf3cf 100644
--- a/drivers/net/wireless/wl12xx/wl1251_spi.h
+++ b/drivers/net/wireless/wl12xx/wl1251_spi.h
@@ -4,8 +4,6 @@
  * Copyright (c) 1998-2007 Texas Instruments Incorporated
  * Copyright (C) 2008 Nokia Corporation
  *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * version 2 as published by the Free Software Foundation.
diff --git a/drivers/net/wireless/wl12xx/wl1251_tx.c b/drivers/net/wireless/wl12xx/wl1251_tx.c
index 6634b3e..6d618fb 100644
--- a/drivers/net/wireless/wl12xx/wl1251_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1251_tx.c
@@ -4,8 +4,6 @@
  * Copyright (c) 1998-2007 Texas Instruments Incorporated
  * Copyright (C) 2008 Nokia Corporation
  *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * version 2 as published by the Free Software Foundation.
diff --git a/drivers/net/wireless/wl12xx/wl1251_tx.h b/drivers/net/wireless/wl12xx/wl1251_tx.h
index f40eeb3..96011e7 100644
--- a/drivers/net/wireless/wl12xx/wl1251_tx.h
+++ b/drivers/net/wireless/wl12xx/wl1251_tx.h
@@ -4,8 +4,6 @@
  * Copyright (c) 1998-2007 Texas Instruments Incorporated
  * Copyright (C) 2008 Nokia Corporation
  *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * version 2 as published by the Free Software Foundation.

