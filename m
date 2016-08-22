Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:51837 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754537AbcHVShX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Aug 2016 14:37:23 -0400
From: Colin King <colin.king@canonical.com>
To: Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] zd1211rw: fix spelling mistake "firmeware" -> "firmware"
Date: Mon, 22 Aug 2016 19:35:05 +0100
Message-Id: <20160822183505.26568-1-colin.king@canonical.com> (sfid-20160822_204418_993731_607294A8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in dev_err message.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/zydas/zd1211rw/zd_usb.c b/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
index a912dc0..c5effd6c 100644
--- a/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
@@ -193,7 +193,7 @@ static int upload_code(struct usb_device *udev,
 			0, 0, p, sizeof(ret), 5000 /* ms */);
 		if (r != sizeof(ret)) {
 			dev_err(&udev->dev,
-				"control request firmeware confirmation failed."
+				"control request firmware confirmation failed."
 				" Return value %d\n", r);
 			if (r >= 0)
 				r = -ENODEV;
-- 
2.9.3
