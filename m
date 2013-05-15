Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:48651 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759455Ab3EOOwh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 May 2013 10:52:37 -0400
Subject: [PATCH 23/29] ath10k: add trace.c
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k-devel@qca.qualcomm.com
Date: Wed, 15 May 2013 17:46:04 +0300
Message-ID: <20130515144604.4492.55935.stgit@localhost6.localdomain6> (sfid-20130515_165259_581830_B6BA5381)
In-Reply-To: <20130515143356.4492.43033.stgit@localhost6.localdomain6>
References: <20130515143356.4492.43033.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/trace.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)
 create mode 100644 drivers/net/wireless/ath/ath10k/trace.c

diff --git a/drivers/net/wireless/ath/ath10k/trace.c b/drivers/net/wireless/ath/ath10k/trace.c
new file mode 100644
index 0000000..4a31e2c
--- /dev/null
+++ b/drivers/net/wireless/ath/ath10k/trace.c
@@ -0,0 +1,20 @@
+/*
+ * Copyright (c) 2012 Qualcomm Atheros, Inc.
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
+#include <linux/module.h>
+
+#define CREATE_TRACE_POINTS
+#include "trace.h"

