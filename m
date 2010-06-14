Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39852 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab0FNEo7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 00:44:59 -0400
Received: by vws14 with SMTP id 14so113542vws.19
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jun 2010 21:44:58 -0700 (PDT)
Message-ID: <4C15B3C4.4030602@gmail.com>
Date: Mon, 14 Jun 2010 00:44:52 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: [PATCH]compat: trivial fix for typo in config.mk
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit e96ac45542ab5f02d2b13981df3a9c34d990afbf
Author: Rick Farina <sidhayn@gmail.com>
Date:   Mon Jun 14 00:40:03 2010 -0400

    [PATCH]compat: trivial fix for typo in config.mk
    
    In config.mk we find "# CONFIG_RT2X00_LIB_DEBUGFS" which clearly
    should have an "=y" at the end like ever other config line.
    
    Signed-off-by: Rick Farina <sidhayn@gmail.com>

diff --git a/config.mk b/config.mk
index 0001a7d..adebbbf 100644
--- a/config.mk
+++ b/config.mk
@@ -453,7 +453,7 @@ CONFIG_RT2X00_LIB_FIRMWARE=y
 CONFIG_RT2X00_LIB_CRYPTO=y
 CONFIG_RT2X00_LIB_LEDS=y
 # CONFIG_RT2X00_DEBUG=y
-# CONFIG_RT2X00_LIB_DEBUGFS
+# CONFIG_RT2X00_LIB_DEBUGFS=y
 endif
 
 ifeq ($(NEED_RT2X00_FIRMWARE),y)

