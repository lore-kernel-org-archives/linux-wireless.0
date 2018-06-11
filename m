Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:40707 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754224AbeFKVKG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Jun 2018 17:10:06 -0400
Received: by mail-pf0-f196.google.com with SMTP id z24-v6so10884769pfe.7
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jun 2018 14:10:05 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>,
        <linux-kernel@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH 4/4] ath10k: snoc: sort include files
Date: Mon, 11 Jun 2018 14:09:46 -0700
Message-Id: <20180611210946.241341-4-briannorris@chromium.org> (sfid-20180611_231048_347168_FBF292F0)
In-Reply-To: <20180611210946.241341-1-briannorris@chromium.org>
References: <20180611210946.241341-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sort these alphabetically, with local includes in a separate section.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/ath/ath10k/snoc.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 61967c2966e6..c88677e0a21c 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -14,18 +14,19 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include <linux/module.h>
+#include <linux/clk.h>
 #include <linux/kernel.h>
-#include "debug.h"
-#include "hif.h"
-#include "htc.h"
-#include "ce.h"
-#include "snoc.h"
+#include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/consumer.h>
-#include <linux/clk.h>
+
+#include "ce.h"
+#include "debug.h"
+#include "hif.h"
+#include "htc.h"
+#include "snoc.h"
 
 #define ATH10K_SNOC_RX_POST_RETRY_MS 50
 #define CE_POLL_PIPE 4
-- 
2.18.0.rc1.242.g61856ae69a-goog
