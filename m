Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.189]:38808 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721AbXK0TmE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 14:42:04 -0500
Received: by mu-out-0910.google.com with SMTP id i10so1396181mue
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2007 11:42:03 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 11/11] rt2x00: Release rt2x00 2.0.13
Date: Tue, 27 Nov 2007 21:52:13 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200711272146.53518.IvDoorn@gmail.com>
In-Reply-To: <200711272146.53518.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200711272152.13282.IvDoorn@gmail.com> (sfid-20071127_200530_919200_20285D5B)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 218068b..85cfdab 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -43,7 +43,7 @@
 /*
  * Module information.
  */
-#define DRV_VERSION	"2.0.12"
+#define DRV_VERSION	"2.0.13"
 #define DRV_PROJECT	"http://rt2x00.serialmonkey.com"
 
 /*
-- 
1.5.3.6

