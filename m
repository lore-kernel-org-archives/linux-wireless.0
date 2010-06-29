Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:37088 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755803Ab0F2TvI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 15:51:08 -0400
Received: by wwb18 with SMTP id 18so553wwb.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jun 2010 12:51:06 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 10/21] eeprom_93cx6: Add support for 93c86 EEPROMs.
Date: Tue, 29 Jun 2010 21:43:44 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <201006292138.13509.IvDoorn@gmail.com> <201006292142.24144.IvDoorn@gmail.com> <201006292143.04173.IvDoorn@gmail.com>
In-Reply-To: <201006292143.04173.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006292143.45392.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@gmail.com>

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 include/linux/eeprom_93cx6.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/eeprom_93cx6.h b/include/linux/eeprom_93cx6.h
index a55c873..c4627cb 100644
--- a/include/linux/eeprom_93cx6.h
+++ b/include/linux/eeprom_93cx6.h
@@ -30,6 +30,7 @@
 #define PCI_EEPROM_WIDTH_93C46	6
 #define PCI_EEPROM_WIDTH_93C56	8
 #define PCI_EEPROM_WIDTH_93C66	8
+#define PCI_EEPROM_WIDTH_93C86	8
 #define PCI_EEPROM_WIDTH_OPCODE	3
 #define PCI_EEPROM_WRITE_OPCODE	0x05
 #define PCI_EEPROM_READ_OPCODE	0x06
-- 
1.6.6.1

