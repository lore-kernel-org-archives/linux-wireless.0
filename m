Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:41879 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab0G1XrJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 19:47:09 -0400
Date: Thu, 29 Jul 2010 01:47:04 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mwl8k: change maintenance status
Message-ID: <20100728234704.GZ21121@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 8366 AP support in particular is still rather incomplete, but
this is unlikely to be addressed any time soon.

Signed-off-by: Lennert Buytenhek <buytenh@wantstofly.org>

diff --git a/MAINTAINERS b/MAINTAINERS
index c9a3fe0..8edb240 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3619,7 +3619,7 @@ F:	include/linux/mv643xx.h
 MARVELL MWL8K WIRELESS DRIVER
 M:	Lennert Buytenhek <buytenh@wantstofly.org>
 L:	linux-wireless@vger.kernel.org
-S:	Maintained
+S:	Odd Fixes
 F:	drivers/net/wireless/mwl8k.c
 
 MARVELL SOC MMC/SD/SDIO CONTROLLER DRIVER
