Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:53309 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751629AbYFDDKU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2008 23:10:20 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	"John W. Linville" <linville@tuxdriver.com>,
	Dmitry Torokhov <dtor@mail.ru>
Subject: [PATCH 02/12] rfkill: fix minor typo in kernel doc
Date: Wed,  4 Jun 2008 00:10:07 -0300
Message-Id: <1212549017-30144-3-git-send-email-hmh@hmh.eng.br> (sfid-20080604_051028_132258_93143DC3)
In-Reply-To: <1212549017-30144-1-git-send-email-hmh@hmh.eng.br>
References: <1212549017-30144-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix a minor typo in an exported function documentation

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
---
 net/rfkill/rfkill.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index 4e10a95..f95081a 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -412,7 +412,7 @@ int rfkill_register(struct rfkill *rfkill)
 EXPORT_SYMBOL(rfkill_register);
 
 /**
- * rfkill_unregister - Uegister a rfkill structure.
+ * rfkill_unregister - Unregister a rfkill structure.
  * @rfkill: rfkill structure to be unregistered
  *
  * This function should be called by the network driver during device
-- 
1.5.5.3

