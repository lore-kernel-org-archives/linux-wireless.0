Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:38841 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751913Ab0AYWdh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 17:33:37 -0500
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] Add rfkill type "fm" to the man page.
Date: Mon, 25 Jan 2010 22:33:31 +0000
Message-Id: <1264458811-21411-3-git-send-email-linux@youmustbejoking.demon.co.uk>
In-Reply-To: <1264458811-21411-2-git-send-email-linux@youmustbejoking.demon.co.uk>
References: <1264458811-21411-1-git-send-email-linux@youmustbejoking.demon.co.uk>
 <1264458811-21411-2-git-send-email-linux@youmustbejoking.demon.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 rfkill.8 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/rfkill.8 b/rfkill.8
index 5bce9fd..aa11fde 100644
--- a/rfkill.8
+++ b/rfkill.8
@@ -24,7 +24,7 @@ or just all of the given type.
 .BI block " index|type"
 Disable the device corresponding to the given index.
 \fItype\fR is one of "all", "wifi", "wlan", "bluetooth", "uwb",
-"ultrawideband", "wimax", "wwan" or "gps".
+"ultrawideband", "wimax", "wwan", "gps" or "fm".
 .TP
 .BI unblock " index|type"
 Enable the device corresponding to the given index. If the device is
-- 
1.6.5

