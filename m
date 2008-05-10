Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:21084 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbYEJMKQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2008 08:10:16 -0400
Received: by nf-out-0910.google.com with SMTP id d3so883147nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 10 May 2008 05:10:16 -0700 (PDT)
To: linville@tuxdriver.com
Subject: [PATCH 15/16] rt2x00: Remove extra +
Date: Sat, 10 May 2008 13:45:58 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200805101337.14536.IvDoorn@gmail.com>
In-Reply-To: <200805101337.14536.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200805101345.58757.IvDoorn@gmail.com> (sfid-20080510_141032_636847_58760BC8)
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 33e7750..f5551e5 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1042,7 +1042,7 @@ static void rt2400pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 			   test_bit(ENTRY_TXD_RTS_FRAME, &txdesc->flags));
 	rt2x00_set_field32(&word, TXD_W0_IFS, txdesc->ifs);
 	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE,
-+			   test_bit(ENTRY_TXD_RETRY_MODE, &txdesc->flags));
+			   test_bit(ENTRY_TXD_RETRY_MODE, &txdesc->flags));
 	rt2x00_desc_write(txd, 0, word);
 }
 
-- 
1.5.5.1

