Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:4082 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbXJ0LZh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Oct 2007 07:25:37 -0400
Received: by nf-out-0910.google.com with SMTP id g13so973044nfb
        for <linux-wireless@vger.kernel.org>; Sat, 27 Oct 2007 04:25:36 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 21/21] rt2x00: Release rt2x00 2.0.12
Date: Sat, 27 Oct 2007 13:44:08 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200710271334.34192.IvDoorn@gmail.com>
In-Reply-To: <200710271334.34192.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710271344.08795.IvDoorn@gmail.com> (sfid-20071027_122539_481200_2D19005A)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Version bump.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index c555abb..82014d8 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -43,7 +43,7 @@
  * Module information.
  * DRV_NAME should be set within the individual module source files.
  */
-#define DRV_VERSION	"2.0.11"
+#define DRV_VERSION	"2.0.12"
 #define DRV_PROJECT	"http://rt2x00.serialmonkey.com"
 
 /*
-- 
1.5.3.4

