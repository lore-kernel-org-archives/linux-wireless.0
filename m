Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52268 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755681Ab2B0X5l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 18:57:41 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, b43-dev@lists.infradead.org,
	linux-mips@linux-mips.org, linux-wireless@vger.kernel.org,
	arend@broadcom.com, m@bues.ch, ralf@linux-mips.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 04/11] ssb: add alpha2
Date: Tue, 28 Feb 2012 00:56:07 +0100
Message-Id: <1330386974-4056-5-git-send-email-hauke@hauke-m.de> (sfid-20120228_005745_862525_D3BB4791)
In-Reply-To: <1330386974-4056-1-git-send-email-hauke@hauke-m.de>
References: <1330386974-4056-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This member contains the country code encoded with two chars

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/ssb/ssb.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/ssb/ssb.h b/include/linux/ssb/ssb.h
index 4928419..d658de4 100644
--- a/include/linux/ssb/ssb.h
+++ b/include/linux/ssb/ssb.h
@@ -33,6 +33,7 @@ struct ssb_sprom {
 	u8 et1mdcport;		/* MDIO for enet1 */
 	u16 board_rev;		/* Board revision number from SPROM. */
 	u8 country_code;	/* Country Code */
+	char alpha2[2];		/* Country Code as two chars like EU or US */
 	u8 leddc_on_time;	/* LED Powersave Duty Cycle On Count */
 	u8 leddc_off_time;	/* LED Powersave Duty Cycle Off Count */
 	u8 ant_available_a;	/* 2GHz antenna available bits (up to 4) */
-- 
1.7.5.4

