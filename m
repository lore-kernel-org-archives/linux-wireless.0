Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.241]:33786 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbYBCO47 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Feb 2008 09:56:59 -0500
Received: by an-out-0708.google.com with SMTP id d31so436419and.103
        for <linux-wireless@vger.kernel.org>; Sun, 03 Feb 2008 06:56:56 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 19/19] rt2x00: Release rt2x00 2.1.0
Date: Sun, 3 Feb 2008 15:56:02 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802031541.52167.IvDoorn@gmail.com>
In-Reply-To: <200802031541.52167.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802031556.02474.IvDoorn@gmail.com> (sfid-20080203_145702_167306_006E5376)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 76270e9..f6ec9fe 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -44,7 +44,7 @@
 /*
  * Module information.
  */
-#define DRV_VERSION	"2.0.14"
+#define DRV_VERSION	"2.1.0"
 #define DRV_PROJECT	"http://rt2x00.serialmonkey.com"
 
 /*
-- 
1.5.3.8

