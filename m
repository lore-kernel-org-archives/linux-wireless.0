Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:51738 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517Ab3FAL1E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Jun 2013 07:27:04 -0400
Subject: [PATCH v2 23/29] ath10k: add trace.c
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k-devel@qca.qualcomm.com
Date: Sat, 01 Jun 2013 14:27:00 +0300
Message-ID: <20130601112700.32443.38564.stgit@localhost6.localdomain6> (sfid-20130601_132707_746871_22F66641)
In-Reply-To: <20130601111820.32443.46794.stgit@localhost6.localdomain6>
References: <20130601111820.32443.46794.stgit@localhost6.localdomain6>
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

