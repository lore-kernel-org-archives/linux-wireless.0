Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 62.81.188.219.static.user.ono.com ([62.81.188.219]:22653 "EHLO
	BCNSRV02.futurlink.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750704AbZI2P1g convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2009 11:27:36 -0400
From: Genar Codina <Genar.Codina@futurlink.com>
To: rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	szalat <szalat@gmail.com>
Date: Tue, 29 Sep 2009 17:21:28 +0200
Subject: RE: [rt2x00-users] [PATCH] rt2x00: Thrustmaster FunAccess WIFI USB
 and rt73usb
Message-ID: <38F8A7B624E06848B97136504F05BB180F4DA926FC@BCNSRV02.futurlink.local>
References: <200909291537.54334.IvDoorn@gmail.com>
In-Reply-To: <200909291537.54334.IvDoorn@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I have also tested the rt73usb which is included in the new 2.6.31 kernel (modinfo rt73usb gives the version "2.3.0"), in mode Master, using hostapd (version 0.6.9) and it works OK.

Regards,
 

-----Mensaje original-----
De: users-bounces@rt2x00.serialmonkey.com [mailto:users-bounces@rt2x00.serialmonkey.com] En nombre de Ivo van Doorn
Enviado el: martes, 29 de septiembre de 2009 15:38
Para: John Linville; linux-wireless@vger.kernel.org; szalat; users@rt2x00.serialmonkey.com
Asunto: [rt2x00-users] [PATCH] rt2x00: Thrustmaster FunAccess WIFI USB and rt73usb

From: Michal Szalata <szalat@gmail.com>

Thrustmaster FunAccess WIFI USB works with rt73usb with little
modification of rt73usb.c.
Tested with version 2.3.0 of driver.

Signed-off-by: Michal Szalata <szalat@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 1cbd9b4..b8f5ee3 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2381,6 +2381,7 @@ static struct usb_device_id rt73usb_device_table[] = {
 	/* Huawei-3Com */
 	{ USB_DEVICE(0x1472, 0x0009), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* Hercules */
+	{ USB_DEVICE(0x06f8, 0xe002), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x06f8, 0xe010), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x06f8, 0xe020), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* Linksys */

_______________________________________________
users mailing list
users@rt2x00.serialmonkey.com
http://rt2x00.serialmonkey.com/mailman/listinfo/users_rt2x00.serialmonkey.com
