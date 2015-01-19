Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:45156 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbbASR1K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2015 12:27:10 -0500
From: Peter Poklop <peter.poklop@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
	Jes.Sorensen@redhat.com
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, Peter Poklop <peter.poklop@gmail.com>
Subject: [PATCH v2] Staging: rtl8723au: fix space coding style issue in os_intfs.c
Date: Mon, 19 Jan 2015 18:26:53 +0100
Message-Id: <1421688413-6701-1-git-send-email-peter.poklop@gmail.com> (sfid-20150119_182714_235634_B46D39DB)
In-Reply-To: <1421506365-9171-1-git-send-email-peter.poklop@gmail.com>
References: <1421506365-9171-1-git-send-email-peter.poklop@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the checkpatch.pl warning:

WARNING: space prohibited before semicolon

Signed-off-by: Peter Poklop <peter.poklop@gmail.com>
---
v2: Commit message cleanup

 drivers/staging/rtl8723au/os_dep/os_intfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723au/os_dep/os_intfs.c b/drivers/staging/rtl8723au/os_dep/os_intfs.c
index 9966d16..1b23eb1 100644
--- a/drivers/staging/rtl8723au/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8723au/os_dep/os_intfs.c
@@ -91,7 +91,7 @@ static int rtw_bt_iso = 2;/*  0:Low, 1:High, 2:From Efuse */
 /*  0:Idle, 1:None-SCO, 2:SCO, 3:From Counter, 4.Busy, 5.OtherBusy */
 static int rtw_bt_sco = 3;
 /*  0:Disable BT control A-MPDU, 1:Enable BT control A-MPDU. */
-static int rtw_bt_ampdu = 1 ;
+static int rtw_bt_ampdu = 1;
 #endif
 
 /*  0:Reject AP's Add BA req, 1:Accept AP's Add BA req. */
-- 
2.1.0

