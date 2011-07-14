Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:51359 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab1GNTKt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 15:10:49 -0400
Received: by fxd18 with SMTP id 18so1505335fxd.11
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jul 2011 12:10:48 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/4] ssb: SPROM: add LED duty cycle fields
Date: Thu, 14 Jul 2011 21:49:18 +0200
Message-Id: <1310672961-5311-1-git-send-email-zajec5@gmail.com> (sfid-20110714_211052_432955_64102A4C)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 include/linux/ssb/ssb.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/ssb/ssb.h b/include/linux/ssb/ssb.h
index 252e4482..f793dfd 100644
--- a/include/linux/ssb/ssb.h
+++ b/include/linux/ssb/ssb.h
@@ -27,6 +27,8 @@ struct ssb_sprom {
 	u8 et1mdcport;		/* MDIO for enet1 */
 	u8 board_rev;		/* Board revision number from SPROM. */
 	u8 country_code;	/* Country Code */
+	u16 leddc_on_time;	/* LED Powersave Duty Cycle On Count */
+	u16 leddc_off_time;	/* LED Powersave Duty Cycle Off Count */
 	u8 ant_available_a;	/* 2GHz antenna available bits (up to 4) */
 	u8 ant_available_bg;	/* 5GHz antenna available bits (up to 4) */
 	u16 pa0b0;
-- 
1.7.3.4

