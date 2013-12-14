Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:56689 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612Ab3LNTLo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Dec 2013 14:11:44 -0500
Received: by mail-we0-f172.google.com with SMTP id w62so3178209wes.31
        for <linux-wireless@vger.kernel.org>; Sat, 14 Dec 2013 11:11:43 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH] wireless: update MAINTAINERS
Date: Sat, 14 Dec 2013 20:11:39 +0100
Message-Id: <1387048299-16508-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20131214_201147_067246_50031686)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've thrown the towel at QCA.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c61df45..1fd6fe5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1435,7 +1435,7 @@ F:	Documentation/aoe/
 F:	drivers/block/aoe/
 
 ATHEROS ATH GENERIC UTILITIES
-M:	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
+M:	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
 L:	linux-wireless@vger.kernel.org
 S:	Supported
 F:	drivers/net/wireless/ath/*
@@ -1443,7 +1443,7 @@ F:	drivers/net/wireless/ath/*
 ATHEROS ATH5K WIRELESS DRIVER
 M:	Jiri Slaby <jirislaby@gmail.com>
 M:	Nick Kossifidis <mickflemm@gmail.com>
-M:	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
+M:	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
 L:	linux-wireless@vger.kernel.org
 L:	ath5k-devel@lists.ath5k.org
 W:	http://wireless.kernel.org/en/users/Drivers/ath5k
-- 
1.8.4.3

