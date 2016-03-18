Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:36447 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870AbcCRRPq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2016 13:15:46 -0400
Received: by mail-wm0-f51.google.com with SMTP id l124so38912765wmf.1
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2016 10:15:46 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Kalle Valo <kvalo@codeaurora.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Linux Driver Project Developer List
	<driverdev-devel@linuxdriverproject.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] staging: refresh TODO for rtl8723au
Date: Fri, 18 Mar 2016 18:15:24 +0100
Message-Id: <1458321324-16906-1-git-send-email-xose.vazquez@gmail.com> (sfid-20160318_181550_317348_FF946DA9)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

People should not waste time and energy working on this staging driver.
A replacement(rtl8xxxu) using the kernel wireless stack already was merged
in the 4.3 kernel.

Cc: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Driver Project Developer List <driverdev-devel@linuxdriverproject.org>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/staging/rtl8723au/TODO | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/rtl8723au/TODO b/drivers/staging/rtl8723au/TODO
index f5d57d3..42b86e4 100644
--- a/drivers/staging/rtl8723au/TODO
+++ b/drivers/staging/rtl8723au/TODO
@@ -9,5 +9,8 @@ TODO:
 - merge Realtek's bugfixes and new features into the driver
 - switch to use MAC80211
 
+A mac80211 driver for this hardware already was integrated at
+drivers/net/wireless/realtek/rtl8xxxu/
+
 Please send any patches to Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Jes Sorensen <Jes.Sorensen@redhat.com>, and Larry Finger <Larry.Finger@lwfinger.net>.
-- 
2.5.0

