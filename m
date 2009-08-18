Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:45776 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786AbZHRD4A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 23:56:00 -0400
Date: Tue, 18 Aug 2009 05:56:01 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 29/29] MAINTAINERS: add information for mwl8k wireless driver
Message-ID: <20090818035601.GH18639@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index cc9ce9e..8d8d495 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3272,6 +3272,12 @@ S:	Supported
 F:	drivers/net/mv643xx_eth.*
 F:	include/linux/mv643xx.h
 
+MARVELL MWL8K WIRELESS DRIVER
+M:	Lennert Buytenhek <buytenh@marvell.com>
+L:	linux-wireless@vger.kernel.org
+S:	Supported
+F:	drivers/net/wireless/mwl8k.c
+
 MARVELL SOC MMC/SD/SDIO CONTROLLER DRIVER
 M:	Nicolas Pitre <nico@cam.org>
 S:	Maintained
-- 
1.5.6.4
