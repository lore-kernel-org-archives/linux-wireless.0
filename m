Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:54636 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab3JJJha (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Oct 2013 05:37:30 -0400
Received: by mail-ea0-f171.google.com with SMTP id n15so1011219ead.30
        for <linux-wireless@vger.kernel.org>; Thu, 10 Oct 2013 02:37:29 -0700 (PDT)
From: Emanuel Taube <emanuel.taube@gmail.com>
To: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Cc: Emanuel Taube <emanuel.taube@gmail.com>
Subject: [PATCH] Remove obsolete country code CS from regdb
Date: Thu, 10 Oct 2013 11:36:50 +0200
Message-Id: <1381397810-5600-1-git-send-email-emanuel.taube@gmail.com> (sfid-20131010_113733_609329_61A544EC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CS (Serbia and Montenegro) is split into RS (Serbia)
and ME (Montenegro).
http://www.statoids.com/w3166his.html

Signed-off-by: Emanuel Taube <emanuel.taube@gmail.com>

diff --git a/db.txt b/db.txt
index c5861b8..ca42a3c 100644
--- a/db.txt
+++ b/db.txt
@@ -181,12 +181,6 @@ country CR:
 	(5250 - 5330 @ 20), (3, 23), DFS
 	(5735 - 5835 @ 20), (3, 30)
 
-country CS:
-	(2402 - 2482 @ 40), (N/A, 20)
-	(5170 - 5250 @ 40), (N/A, 20)
-	(5250 - 5330 @ 40), (N/A, 20), DFS
-	(5490 - 5710 @ 40), (N/A, 27), DFS
-
 country CY: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
-- 
1.7.10.4

