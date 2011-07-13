Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:51694 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab1GMUGZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 16:06:25 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] MAINTAINERS: add entry for Marvell mwifiex wireless driver
Date: Wed, 13 Jul 2011 13:11:58 -0700
Message-Id: <1310587918-29744-1-git-send-email-bzhao@marvell.com> (sfid-20110713_220627_967395_42EAB26E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 187282d..21afb51 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4097,6 +4097,12 @@ S:	Maintained
 F:	drivers/net/mv643xx_eth.*
 F:	include/linux/mv643xx.h
 
+MARVELL MWIFIEX WIRELESS DRIVER
+M:	Bing Zhao <bzhao@marvell.com>
+L:	linux-wireless@vger.kernel.org
+S:	Maintained
+F:	drivers/net/wireless/mwifiex/
+
 MARVELL MWL8K WIRELESS DRIVER
 M:	Lennert Buytenhek <buytenh@wantstofly.org>
 L:	linux-wireless@vger.kernel.org
-- 
1.7.0.2

