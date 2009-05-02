Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:40735 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762595AbZEBUHS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 May 2009 16:07:18 -0400
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH] add version.h to .gitignore
Date: Sat,  2 May 2009 13:07:06 -0700
Message-Id: <1241294826-27585-1-git-send-email-marcel@holtmann.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 .gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/.gitignore b/.gitignore
index 16bb88b..edc6864 100644
--- a/.gitignore
+++ b/.gitignore
@@ -3,5 +3,6 @@ iw
 *.o
 .config
 version.c
+version.h
 iw.8.gz
 *-stamp
-- 
1.6.0.6

