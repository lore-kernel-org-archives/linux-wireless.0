Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:58837 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab2BFOp6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 09:45:58 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH] ath6kl: Update license header
Date: Mon, 6 Feb 2012 20:15:53 +0530
Message-ID: <1328539553-9616-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120206_154602_727541_393D17B2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update license header with the copyright to Qualcomm Atheros, Inc.
for the year 2011-2012.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/Makefile   |    3 ++-
 drivers/net/wireless/ath/ath6kl/bmi.c      |    1 +
 drivers/net/wireless/ath/ath6kl/bmi.h      |    1 +
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    1 +
 drivers/net/wireless/ath/ath6kl/cfg80211.h |    1 +
 drivers/net/wireless/ath/ath6kl/common.h   |    1 +
 drivers/net/wireless/ath/ath6kl/core.c     |    1 +
 drivers/net/wireless/ath/ath6kl/core.h     |    1 +
 drivers/net/wireless/ath/ath6kl/debug.c    |    1 +
 drivers/net/wireless/ath/ath6kl/debug.h    |    1 +
 drivers/net/wireless/ath/ath6kl/hif-ops.h  |    1 +
 drivers/net/wireless/ath/ath6kl/hif.c      |    1 +
 drivers/net/wireless/ath/ath6kl/hif.h      |    1 +
 drivers/net/wireless/ath/ath6kl/htc.c      |    1 +
 drivers/net/wireless/ath/ath6kl/htc.h      |    1 +
 drivers/net/wireless/ath/ath6kl/init.c     |    1 +
 drivers/net/wireless/ath/ath6kl/main.c     |    1 +
 drivers/net/wireless/ath/ath6kl/sdio.c     |    1 +
 drivers/net/wireless/ath/ath6kl/target.h   |    1 +
 drivers/net/wireless/ath/ath6kl/testmode.c |    1 +
 drivers/net/wireless/ath/ath6kl/testmode.h |    1 +
 drivers/net/wireless/ath/ath6kl/txrx.c     |    1 +
 drivers/net/wireless/ath/ath6kl/usb.c      |    1 +
 drivers/net/wireless/ath/ath6kl/wmi.c      |    1 +
 drivers/net/wireless/ath/ath6kl/wmi.h      |    1 +
 25 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/Makefile b/drivers/net/wireless/ath/ath6kl/Makefile
index 9ba42fa..85746c3 100644
--- a/drivers/net/wireless/ath/ath6kl/Makefile
+++ b/drivers/net/wireless/ath/ath6kl/Makefile
@@ -1,5 +1,6 @@
 #------------------------------------------------------------------------------
-# Copyright (c) 2004-2010 Atheros Communications Inc.
+# Copyright (c) 2004-2011 Atheros Communications Inc.
+# Copyright (c) 2011-2012 Qualcomm Atheros, Inc.
 # All rights reserved.
 #
 #
diff --git a/drivers/net/wireless/ath/ath6kl/bmi.c b/drivers/net/wireless/ath/ath6kl/bmi.c
index aef00d5..05d1d89 100644
--- a/drivers/net/wireless/ath/ath6kl/bmi.c
+++ b/drivers/net/wireless/ath/ath6kl/bmi.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2004-2011 Atheros Communications Inc.
+ * Copyright (c) 2011-2012 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath6kl/bmi.h b/drivers/net/wireless/ath/ath6kl/bmi.h
index f1ca681..114f7b2 100644
--- a/drivers/net/wireless/ath/ath6kl/bmi.h
+++ b/drivers/net/wireless/ath/ath6kl/bmi.h
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2004-2011 Atheros Communications Inc.
+ * Copyright (c) 2011 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index d1922d8..a91f521 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2004-2011 Atheros Communications Inc.
+ * Copyright (c) 2011-2012 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.h b/drivers/net/wireless/ath/ath6kl/cfg80211.h
index 3c693b7..c5def43 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.h
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.h
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2011 Atheros Communications Inc.
+ * Copyright (c) 2011-2012 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath6kl/common.h b/drivers/net/wireless/ath/ath6kl/common.h
index f89f1e1..a60e78c 100644
--- a/drivers/net/wireless/ath/ath6kl/common.h
+++ b/drivers/net/wireless/ath/ath6kl/common.h
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2010-2011 Atheros Communications Inc.
+ * Copyright (c) 2011-2012 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath6kl/core.c b/drivers/net/wireless/ath/ath6kl/core.c
index 722ca59..c4926cf 100644
--- a/drivers/net/wireless/ath/ath6kl/core.c
+++ b/drivers/net/wireless/ath/ath6kl/core.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2004-2011 Atheros Communications Inc.
+ * Copyright (c) 2011-2012 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index c4d66e0..e32f785 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2010-2011 Atheros Communications Inc.
+ * Copyright (c) 2011-2012 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index d832058..0acba97 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2004-2011 Atheros Communications Inc.
+ * Copyright (c) 2011-2012 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath6kl/debug.h b/drivers/net/wireless/ath/ath6kl/debug.h
index c4be6e5..c5d5e6c 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.h
+++ b/drivers/net/wireless/ath/ath6kl/debug.h
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2011 Atheros Communications Inc.
+ * Copyright (c) 2011-2012 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath6kl/hif-ops.h b/drivers/net/wireless/ath/ath6kl/hif-ops.h
index 2fe1dad..fd84086 100644
--- a/drivers/net/wireless/ath/ath6kl/hif-ops.h
+++ b/drivers/net/wireless/ath/ath6kl/hif-ops.h
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2004-2011 Atheros Communications Inc.
+ * Copyright (c) 2011 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath6kl/hif.c b/drivers/net/wireless/ath/ath6kl/hif.c
index e911737..18c7f64 100644
--- a/drivers/net/wireless/ath/ath6kl/hif.c
+++ b/drivers/net/wireless/ath/ath6kl/hif.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2007-2011 Atheros Communications Inc.
+ * Copyright (c) 2011-2012 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath6kl/hif.h b/drivers/net/wireless/ath/ath6kl/hif.h
index 699a036..fb4186f 100644
--- a/drivers/net/wireless/ath/ath6kl/hif.h
+++ b/drivers/net/wireless/ath/ath6kl/hif.h
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2004-2011 Atheros Communications Inc.
+ * Copyright (c) 2011 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index 2d72190..1385f71 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2007-2011 Atheros Communications Inc.
+ * Copyright (c) 2011-2012 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath6kl/htc.h b/drivers/net/wireless/ath/ath6kl/htc.h
index 57672e1..84a2ab5 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.h
+++ b/drivers/net/wireless/ath/ath6kl/htc.h
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2004-2011 Atheros Communications Inc.
+ * Copyright (c) 2011 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 0d76c37..6183d57 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1,6 +1,7 @@
 
 /*
  * Copyright (c) 2011 Atheros Communications Inc.
+ * Copyright (c) 2011-2012 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index b96d01a..d463a18 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2004-2011 Atheros Communications Inc.
+ * Copyright (c) 2011-2012 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 4febee7..2826613 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2004-2011 Atheros Communications Inc.
+ * Copyright (c) 2011-2012 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath6kl/target.h b/drivers/net/wireless/ath/ath6kl/target.h
index 108a723..ac27962 100644
--- a/drivers/net/wireless/ath/ath6kl/target.h
+++ b/drivers/net/wireless/ath/ath6kl/target.h
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2004-2010 Atheros Communications Inc.
+ * Copyright (c) 2011 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath6kl/testmode.c b/drivers/net/wireless/ath/ath6kl/testmode.c
index f0cd61d..6675c92 100644
--- a/drivers/net/wireless/ath/ath6kl/testmode.c
+++ b/drivers/net/wireless/ath/ath6kl/testmode.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2010-2011 Atheros Communications Inc.
+ * Copyright (c) 2011 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath6kl/testmode.h b/drivers/net/wireless/ath/ath6kl/testmode.h
index 7fd47a6..fe651d6 100644
--- a/drivers/net/wireless/ath/ath6kl/testmode.h
+++ b/drivers/net/wireless/ath/ath6kl/testmode.h
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2010-2011 Atheros Communications Inc.
+ * Copyright (c) 2011 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index a3dc694..87d4646 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2004-2011 Atheros Communications Inc.
+ * Copyright (c) 2011-2012 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath6kl/usb.c b/drivers/net/wireless/ath/ath6kl/usb.c
index c72567c..325b122 100644
--- a/drivers/net/wireless/ath/ath6kl/usb.c
+++ b/drivers/net/wireless/ath/ath6kl/usb.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2007-2011 Atheros Communications Inc.
+ * Copyright (c) 2011-2012 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 18fa9aa..bbbe0a7 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2004-2011 Atheros Communications Inc.
+ * Copyright (c) 2011-2012 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index e791986..e7d031b 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2010-2011 Atheros Communications Inc.
+ * Copyright (c) 2011-2012 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
-- 
1.7.0.4

