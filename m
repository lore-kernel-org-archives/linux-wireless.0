Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34601 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757343AbcAaNZF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2016 08:25:05 -0500
Received: by mail-pf0-f194.google.com with SMTP id 65so6221203pfd.1
        for <linux-wireless@vger.kernel.org>; Sun, 31 Jan 2016 05:25:05 -0800 (PST)
From: Rakhi Sharma <rakhish1994@gmail.com>
To: Jes.Sorensen@redhat.com, Larry.Finger@lwfinger.net,
	gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Rakhi Sharma <rakhish1994@gmail.com>
Subject: [PATCH 3/3] Staging: rtl8723au: core: rtw_ieee80211: Fixed space and brace coding style issue.
Date: Sun, 31 Jan 2016 18:54:03 +0530
Message-Id: <1454246643-24049-1-git-send-email-rakhish1994@gmail.com> (sfid-20160131_142511_027624_86D3B620)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixed the space and brace coding style error.
ERROR: space required before that '='
ERROR: that open brace { should be on the previous line.

Signed-off-by: Rakhi Sharma <rakhish1994@gmail.com>
---
 drivers/staging/rtl8723au/core/rtw_ieee80211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_ieee80211.c b/drivers/staging/rtl8723au/core/rtw_ieee80211.c
index 3b0d782..0c933e4 100644
--- a/drivers/staging/rtl8723au/core/rtw_ieee80211.c
+++ b/drivers/staging/rtl8723au/core/rtw_ieee80211.c
@@ -65,8 +65,8 @@ static u8 WIFI_OFDMRATES[] = {
 
 int rtw_get_bit_value_from_ieee_value23a(u8 val)
 {
-	unsigned char dot11_rate_table[] =
-			{2, 4, 11, 22, 12, 18, 24, 36, 48, 72, 96, 108, 0};
+	unsigned char dot11_rate_table[] = {
+		2, 4, 11, 22, 12, 18, 24, 36, 48, 72, 96, 108, 0};
 
 	int i = 0;
 
-- 
1.9.1

