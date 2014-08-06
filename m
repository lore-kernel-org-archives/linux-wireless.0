Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24113 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbaHFHc0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2014 03:32:26 -0400
From: Dedy Lansky <qca_dlansky@qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH v2 03/13] wil6210: update copyright year 2014
Date: Wed, 6 Aug 2014 10:31:51 +0300
Message-ID: <1407310322-22568-4-git-send-email-qca_dlansky@qca.qualcomm.com> (sfid-20140806_093230_228206_753206FC)
In-Reply-To: <1407310322-22568-1-git-send-email-qca_dlansky@qca.qualcomm.com>
References: <1407310322-22568-1-git-send-email-qca_dlansky@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

Fix Copyright headers in all files changed in 2014, to mention 2014

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c   |  2 +-
 drivers/net/wireless/ath/wil6210/debugfs.c    |  2 +-
 drivers/net/wireless/ath/wil6210/interrupt.c  |  2 +-
 drivers/net/wireless/ath/wil6210/main.c       |  2 +-
 drivers/net/wireless/ath/wil6210/netdev.c     |  2 +-
 drivers/net/wireless/ath/wil6210/pcie_bus.c   |  2 +-
 drivers/net/wireless/ath/wil6210/rx_reorder.c | 16 ++++++++++++++++
 drivers/net/wireless/ath/wil6210/txrx.c       |  2 +-
 drivers/net/wireless/ath/wil6210/txrx.h       |  2 +-
 drivers/net/wireless/ath/wil6210/wil6210.h    |  2 +-
 drivers/net/wireless/ath/wil6210/wmi.c        |  2 +-
 drivers/net/wireless/ath/wil6210/wmi.h        |  2 +-
 12 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 4ac2c20..ee8a0e5 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ * Copyright (c) 2012-2014 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index dee2380..fb802bd 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ * Copyright (c) 2012-2014 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index 67f1002..98bfbb6 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ * Copyright (c) 2012-2014 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index d734283..dc22053 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ * Copyright (c) 2012-2014 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index 106b6dc..8ee0862 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ * Copyright (c) 2012-2014 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index d3fbfa2..a6af2bb 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ * Copyright (c) 2012-2014 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/wil6210/rx_reorder.c b/drivers/net/wireless/ath/wil6210/rx_reorder.c
index 180ca47..97c6a24 100644
--- a/drivers/net/wireless/ath/wil6210/rx_reorder.c
+++ b/drivers/net/wireless/ath/wil6210/rx_reorder.c
@@ -1,3 +1,19 @@
+/*
+ * Copyright (c) 2014 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
 #include "wil6210.h"
 #include "txrx.h"
 
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index d346794..9fcc2e3 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ * Copyright (c) 2012-2014 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/wil6210/txrx.h b/drivers/net/wireless/ath/wil6210/txrx.h
index bc5706a..a1ac4f8 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.h
+++ b/drivers/net/wireless/ath/wil6210/txrx.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ * Copyright (c) 2012-2014 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 077e623..0097300 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ * Copyright (c) 2012-2014 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 1d1d0af..b25a62d 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ * Copyright (c) 2012-2014 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/wil6210/wmi.h b/drivers/net/wireless/ath/wil6210/wmi.h
index 17334c8..2f51b46 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.h
+++ b/drivers/net/wireless/ath/wil6210/wmi.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ * Copyright (c) 2012-2014 Qualcomm Atheros, Inc.
  * Copyright (c) 2006-2012 Wilocity .
  *
  * Permission to use, copy, modify, and/or distribute this software for any
-- 
1.8.5.2

