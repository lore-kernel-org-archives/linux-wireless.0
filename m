Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48218 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab1A3MYt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 07:24:49 -0500
Received: by mail-ew0-f46.google.com with SMTP id 5so2118506ewy.19
        for <linux-wireless@vger.kernel.org>; Sun, 30 Jan 2011 04:24:48 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 15/21] Trivial typo fix in comment
Date: Sun, 30 Jan 2011 13:22:03 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201101301316.04044.IvDoorn@gmail.com> <201101301321.23510.IvDoorn@gmail.com> <201101301321.42168.IvDoorn@gmail.com>
In-Reply-To: <201101301321.42168.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201101301322.04131.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mark Einon <mark.einon@gmail.com>

  Fixing a trivial comment typo.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 5c88fdc..2725f3c 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -46,7 +46,7 @@
  * These indirect registers work with busy bits,
  * and we will try maximal REGISTER_BUSY_COUNT times to access
  * the register while taking a REGISTER_BUSY_DELAY us delay
- * between each attampt. When the busy bit is still set at that time,
+ * between each attempt. When the busy bit is still set at that time,
  * the access attempt is considered to have failed,
  * and we will print an error.
  */
-- 
1.7.2.3

