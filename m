Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:56700 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388293AbeGXKAN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jul 2018 06:00:13 -0400
From: Daniel Mack <daniel@zonque.org>
To: sameo@linux.intel.com
Cc: linux-wireless@vger.kernel.org, colin.king@canonical.com,
        shikha.singh@st.com, Daniel Mack <daniel@zonque.org>
Subject: [PATCH v2 07/10] NFC: st95hf: re-order command defines
Date: Tue, 24 Jul 2018 10:54:23 +0200
Message-Id: <20180724085426.23999-8-daniel@zonque.org> (sfid-20180724_105456_655120_B02B2062)
In-Reply-To: <20180724085426.23999-1-daniel@zonque.org>
References: <20180724085426.23999-1-daniel@zonque.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just a small cleanup to bring the command defines in a numerical order.

Signed-off-by: Daniel Mack <daniel@zonque.org>
---
 drivers/nfc/st95hf/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/st95hf/core.c b/drivers/nfc/st95hf/core.c
index 99f84ddfdfef..e7ecc57dde8f 100644
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
