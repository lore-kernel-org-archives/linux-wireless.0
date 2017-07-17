Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:35248 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751346AbdGQQDI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 12:03:08 -0400
Received: by mail-it0-f68.google.com with SMTP id v193so18317071itc.2
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jul 2017 09:03:08 -0700 (PDT)
MIME-Version: 1.0
From: Michael Gugino <michael.gugino.2@gmail.com>
Date: Mon, 17 Jul 2017 12:03:07 -0400
Message-ID: <CACHT077fJY0EBYRk+wgnVREoEf-d+Brejq2JngcSpsi_ygV-GA@mail.gmail.com> (sfid-20170717_180314_384052_B4F29F0E)
Subject: [PATCH v2 1/1] rtl8188eu: add TL-WN722N v2 support
To: linux-wireless@vger.kernel.org
Cc: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Gugino <michael.gugino.2@gmail.com>

This patch adds support for USB Device TP-Link TL-WN722N v2.
VendorID: 0x2357, ProductID: 0x010c

Signed-off-by: Michael Gugino <michael.gugino.2@gmail.com>
---
 drivers/staging/rtl8188eu/os_dep/usb_intf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index 963235f..d283341 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -43,6 +43,7 @@ static struct usb_device_id rtw_usb_id_tbl[] = {
  {USB_DEVICE(0x2001, 0x330F)}, /* DLink DWA-125 REV D1 */
  {USB_DEVICE(0x2001, 0x3310)}, /* Dlink DWA-123 REV D1 */
  {USB_DEVICE(0x2001, 0x3311)}, /* DLink GO-USB-N150 REV B1 */
+ {USB_DEVICE(0x2357, 0x010c)}, /* TP-Link TL-WN722N v2 */
  {USB_DEVICE(0x0df6, 0x0076)}, /* Sitecom N150 v2 */
  {} /* Terminating entry */
 };
-- 
2.7.4
