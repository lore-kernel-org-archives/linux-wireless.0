Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:45721 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbbBPWKH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2015 17:10:07 -0500
Received: by mail-wg0-f48.google.com with SMTP id l18so28721358wgh.7
        for <linux-wireless@vger.kernel.org>; Mon, 16 Feb 2015 14:10:04 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-firmware@kernel.org
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] brcm: drop executable from brcmfmac43143-sdio.bin
Date: Mon, 16 Feb 2015 23:09:47 +0100
Message-Id: <1424124587-28065-1-git-send-email-zajec5@gmail.com> (sfid-20150216_231012_105712_C94DFDF8)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It isn't supposed to be run on host obviously.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 brcm/brcmfmac43143-sdio.bin | Bin
 1 file changed, 0 insertions(+), 0 deletions(-)
 mode change 100755 => 100644 brcm/brcmfmac43143-sdio.bin

diff --git a/brcm/brcmfmac43143-sdio.bin b/brcm/brcmfmac43143-sdio.bin
old mode 100755
new mode 100644
-- 
1.8.4.5

