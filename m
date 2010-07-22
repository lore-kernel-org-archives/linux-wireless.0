Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44298 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759242Ab0GVSpO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 14:45:14 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Corey Thomas <coreythomas@charter.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] MAINTAINERS: orphan the raylink wireless driver
Date: Thu, 22 Jul 2010 14:39:03 -0400
Message-Id: <1279823943-21488-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 MAINTAINERS |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2911648..79b0679 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4680,9 +4680,8 @@ S:	Maintained
 F:	drivers/rapidio/
 
 RAYLINK/WEBGEAR 802.11 WIRELESS LAN DRIVER
-M:	Corey Thomas <coreythomas@charter.net>
 L:	linux-wireless@vger.kernel.org
-S:	Maintained
+S:	Orphan
 F:	drivers/net/wireless/ray*
 
 RCUTORTURE MODULE
-- 
1.7.1.1

