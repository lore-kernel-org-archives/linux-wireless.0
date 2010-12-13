Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59140 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab0LMTkL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 14:40:11 -0500
Received: by vws16 with SMTP id 16so3775266vws.19
        for <linux-wireless@vger.kernel.org>; Mon, 13 Dec 2010 11:40:10 -0800 (PST)
From: Dave Vasilevsky <dave@vasilevsky.ca>
To: lrodriguez@atheros.com, linux-wireless@vger.kernel.org
Cc: Dave Vasilevsky <dave@vasilevsky.ca>
Subject: [PATCH] compat-wireless: Rename config option to CONFIG_B43_PHY_N
Date: Mon, 13 Dec 2010 14:39:54 -0500
Message-Id: <1292269194-3850-1-git-send-email-dave@vasilevsky.ca>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Option CONFIG_B43_NPHY has been changed to COPNFIG_B43_PHY_N since linux-next
692d2c0fb36c02ad07d54641c26f48e644b27fbd.

Signed-off-by: Dave Vasilevsky <dave@vasilevsky.ca>
---
 config.mk |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/config.mk b/config.mk
index 015f400..3261aa3 100644
--- a/config.mk
+++ b/config.mk
@@ -245,7 +245,7 @@ CONFIG_B43_PCMCIA=y
 endif #CONFIG_PCMCIA
 CONFIG_B43_LEDS=y
 CONFIG_B43_PHY_LP=y
-CONFIG_B43_NPHY=y
+CONFIG_B43_PHY_N=y
 # CONFIG_B43_FORCE_PIO=y
 # CONFIG_B43_DEBUG=y
 
-- 
1.7.1

