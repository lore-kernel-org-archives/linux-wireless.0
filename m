Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54052 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250Ab1GFVA7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2011 17:00:59 -0400
Received: by mail-ew0-f46.google.com with SMTP id 4so108843ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jul 2011 14:00:59 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 4/6] rt2x00: Add device ID for RT539F device.
Date: Wed, 6 Jul 2011 22:58:55 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
References: <201107062256.25555.IvDoorn@gmail.com> <201107062257.01333.IvDoorn@gmail.com> <201107062257.38435.IvDoorn@gmail.com>
In-Reply-To: <201107062257.38435.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201107062258.56747.IvDoorn@gmail.com> (sfid-20110706_230102_892611_D437055C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@gmail.com>

Reported-by: Wim Vander Schelden <wim@fixnum.org>
Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 5513edf..fd99449 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -1160,6 +1160,7 @@ static DEFINE_PCI_DEVICE_TABLE(rt2800pci_device_table) = {
 #endif
 #ifdef CONFIG_RT2800PCI_RT53XX
 	{ PCI_DEVICE(0x1814, 0x5390) },
+	{ PCI_DEVICE(0x1814, 0x539f) },
 #endif
 	{ 0, }
 };
-- 
1.7.2.3

