Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48560 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752422AbdARAGX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Jan 2017 19:06:23 -0500
From: Jes.Sorensen@gmail.com
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/5] rtl8xxxu: Mark 8192eu device 0x0bda:0x818b as tested
Date: Tue, 17 Jan 2017 18:18:52 -0500
Message-Id: <20170117231856.5075-2-Jes.Sorensen@gmail.com> (sfid-20170118_010626_358392_6818308C)
In-Reply-To: <20170117231856.5075-1-Jes.Sorensen@gmail.com>
References: <20170117231856.5075-1-Jes.Sorensen@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Device reported as working fine, so tell the driver not to warn about
it being untested.

Reported-by: Aex Aey <aexaey@gmail.com>
Signed-off-by: Jes Sorensen <Jes.Sorensen@gmail.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 3a86675..99cfd2b 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -6000,6 +6000,7 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
 		case 0x8176:
 		case 0x8178:
 		case 0x817f:
+		case 0x818b:
 			untested = 0;
 			break;
 		}
-- 
2.7.4
