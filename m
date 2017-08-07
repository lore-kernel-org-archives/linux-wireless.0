Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752001AbdHGWaO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2017 18:30:14 -0400
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kvalo@codeaurora.org, chunkeey@googlemail.com,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH v2 2/2] MAINTAINERS: update email address for mcgrof for few straggling drivers
Date: Mon,  7 Aug 2017 15:30:11 -0700
Message-Id: <20170807223011.21926-3-mcgrof@kernel.org> (sfid-20170808_003037_585059_37D1203C)
In-Reply-To: <20170807223011.21926-1-mcgrof@kernel.org>
References: <20170807223011.21926-1-mcgrof@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will ensure I get emails on my work and personal email address.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3deaddc8c578..997b8062397a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2212,7 +2212,7 @@ F:	drivers/gpio/gpio-ath79.c
 F:	Documentation/devicetree/bindings/gpio/gpio-ath79.txt
 
 ATHEROS ATH GENERIC UTILITIES
-M:	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
+M:	"Luis R. Rodriguez" <mcgrof@kernel.org>
 L:	linux-wireless@vger.kernel.org
 S:	Supported
 F:	drivers/net/wireless/ath/*
@@ -2220,7 +2220,7 @@ F:	drivers/net/wireless/ath/*
 ATHEROS ATH5K WIRELESS DRIVER
 M:	Jiri Slaby <jirislaby@gmail.com>
 M:	Nick Kossifidis <mickflemm@gmail.com>
-M:	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
+M:	"Luis R. Rodriguez" <mcgrof@kernel.org>
 L:	linux-wireless@vger.kernel.org
 W:	http://wireless.kernel.org/en/users/Drivers/ath5k
 S:	Maintained
-- 
2.11.0
