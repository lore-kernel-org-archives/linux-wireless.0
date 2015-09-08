Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:21427 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbbIHIH4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 04:07:56 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 3/5] staging: wilc1000: add maintainers for Atmel 802.11 driver
Date: Tue, 8 Sep 2015 17:08:01 +0900
Message-ID: <1441699683-31463-3-git-send-email-tony.cho@atmel.com> (sfid-20150908_100801_036788_9FD898BA)
In-Reply-To: <1441699683-31463-1-git-send-email-tony.cho@atmel.com>
References: <1441699683-31463-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds new maintainers who develops new design for Atmel 802.11
link controller and deletes Dean Lee who cannot maintain the wireless
driver anymore.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 MAINTAINERS | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4d8c8e1..b704893 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9937,8 +9937,10 @@ F:	drivers/staging/vt665?/
 STAGING - WILC1000 WIFI DRIVER
 M:	Johnny Kim <johnny.kim@atmel.com>
 M:	Rachel Kim <rachel.kim@atmel.com>
-M:	Dean Lee <dean.lee@atmel.com>
 M:	Chris Park <chris.park@atmel.com>
+M:	Tony Cho <tony.cho@atmel.com>
+M:	Glen Lee <glen.lee@atmel.com>
+M:	Leo Kim <leo.kim@atmel.com>
 L:	linux-wireless@vger.kernel.org
 S:	Supported
 F:	drivers/staging/wilc1000/
-- 
1.9.1

