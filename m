Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:14470 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbYBJVyC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Feb 2008 16:54:02 -0500
Received: by nf-out-0910.google.com with SMTP id g13so1187796nfb.21
        for <linux-wireless@vger.kernel.org>; Sun, 10 Feb 2008 13:54:00 -0800 (PST)
To: linville@tuxdriver.com
Subject: [PATCH 14/14] rt2x00: Release rt2x00 2.1.1
Date: Sun, 10 Feb 2008 22:52:56 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802102246.04515.IvDoorn@gmail.com>
In-Reply-To: <200802102246.04515.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802102252.57028.IvDoorn@gmail.com> (sfid-20080210_220813_413372_E715DD96)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 9098532..7a83e0a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -44,7 +44,7 @@
 /*
  * Module information.
  */
-#define DRV_VERSION	"2.1.0"
+#define DRV_VERSION	"2.1.1"
 #define DRV_PROJECT	"http://rt2x00.serialmonkey.com"
 
 /*
-- 
1.5.4

