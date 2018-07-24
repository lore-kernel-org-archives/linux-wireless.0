Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:57174 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388407AbeGXLFq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jul 2018 07:05:46 -0400
From: Daniel Mack <daniel@zonque.org>
To: sameo@linux.intel.com
Cc: linux-wireless@vger.kernel.org, colin.king@canonical.com,
        shikha.singh@st.com, Daniel Mack <daniel@zonque.org>
Subject: [PATCH v3 08/11] NFC: st95hf: re-order command defines
Date: Tue, 24 Jul 2018 11:59:38 +0200
Message-Id: <20180724095941.25777-9-daniel@zonque.org> (sfid-20180724_120140_961405_A3578FF9)
In-Reply-To: <20180724095941.25777-1-daniel@zonque.org>
References: <20180724095941.25777-1-daniel@zonque.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just a small cleanup to bring the command defines in a numerical order.

Signed-off-by: Daniel Mack <daniel@zonque.org>
---
 drivers/nfc/st95hf/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/st95hf/core.c b/drivers/nfc/st95hf/core.c
index 7fdad67b1a4d..53447394666b 100644
--- a/drivers/nfc/st95hf/core.c
+++ b/drivers/nfc/st95hf/core.c
@@ -45,10 +45,10 @@
 
 /* Command Send Interface */
 /* ST95HF_COMMAND_SEND CMD Ids */
-#define ECHO_CMD			0x55
-#define WRITE_REGISTER_CMD		0x9
 #define PROTOCOL_SELECT_CMD		0x2
 #define SEND_RECEIVE_CMD		0x4
+#define WRITE_REGISTER_CMD		0x9
+#define ECHO_CMD			0x55
 
 /* Select protocol codes */
 #define ISO15693_PROTOCOL_CODE		0x1
-- 
2.17.1
