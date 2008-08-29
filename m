Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:63275 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104AbYH2TIH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2008 15:08:07 -0400
Received: by ey-out-2122.google.com with SMTP id 6so320138eyi.37
        for <linux-wireless@vger.kernel.org>; Fri, 29 Aug 2008 12:08:06 -0700 (PDT)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 7/7] rt2x00: Release rt2x00 2.2.1
Date: Fri, 29 Aug 2008 21:07:22 +0200
Cc: "rt2400-devel" <rt2400-devel@lists.sourceforge.net>,
	linux-wireless@vger.kernel.org
References: <200808292103.53179.IvDoorn@gmail.com> <200808292106.01403.IvDoorn@gmail.com> <200808292106.18171.IvDoorn@gmail.com>
In-Reply-To: <200808292106.18171.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200808292107.22535.IvDoorn@gmail.com> (sfid-20080829_210813_747470_7BD6DA41)
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 5e4f783..6f296ce 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -44,7 +44,7 @@
 /*
  * Module information.
  */
-#define DRV_VERSION	"2.2.0"
+#define DRV_VERSION	"2.2.1"
 #define DRV_PROJECT	"http://rt2x00.serialmonkey.com"
 
 /*
-- 
1.5.6.1

