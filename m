Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:42784 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbZLWNXk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 08:23:40 -0500
Received: by iwn1 with SMTP id 1so5105438iwn.33
        for <linux-wireless@vger.kernel.org>; Wed, 23 Dec 2009 05:23:40 -0800 (PST)
Date: Wed, 23 Dec 2009 15:23:19 +0200
From: Dan Carpenter <error27@gmail.com>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [patch] wl1271_cmd.c:  cleanup char => u8
Message-ID: <20091223132319.GC17923@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is just a clean up and doesn't make a functional difference.  It keeps the
lint checkers happy.

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/drivers/net/wireless/wl12xx/wl1271_cmd.c	2009-12-22 22:59:58.000000000 +0200
+++ devel/drivers/net/wireless/wl12xx/wl1271_cmd.c	2009-12-22 23:00:29.000000000 +0200
@@ -777,7 +777,7 @@ out:
 	return ret;
 }
 
-static int wl1271_build_basic_rates(char *rates, u8 band)
+static int wl1271_build_basic_rates(u8 *rates, u8 band)
 {
 	u8 index = 0;
 
@@ -804,7 +804,7 @@ static int wl1271_build_basic_rates(char
 	return index;
 }
 
-static int wl1271_build_extended_rates(char *rates, u8 band)
+static int wl1271_build_extended_rates(u8 *rates, u8 band)
 {
 	u8 index = 0;
 
