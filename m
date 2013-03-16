Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:41927 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755957Ab3CPSUP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Mar 2013 14:20:15 -0400
From: stf_xl@wp.pl
To: "John W. Linville\"" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 23/25] rt2800: 5592: add Kconfig
Date: Sat, 16 Mar 2013 19:19:51 +0100
Message-Id: <1363457993-15541-24-git-send-email-stf_xl@wp.pl> (sfid-20130316_192028_714846_92956089)
In-Reply-To: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
References: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Enable support to 5592 chip.

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/Kconfig |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index 44d6ead..d195454 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -169,6 +169,13 @@ config RT2800USB_RT53XX
          rt2800usb driver.
          Supported chips: RT5370
 
+config RT2800USB_RT55XX
+       bool "rt2800usb - Include support for rt55xx devices (EXPERIMENTAL)"
+       ---help---
+         This adds support for rt55xx wireless chipset family to the
+         rt2800usb driver.
+         Supported chips: RT5572
+
 config RT2800USB_UNKNOWN
 	bool "rt2800usb - Include support for unknown (USB) devices"
 	default n
-- 
1.7.4.4

