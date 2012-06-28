Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41928 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410Ab2F1A0m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 20:26:42 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@qca.qualcomm.com
Subject: [PATCH 01/11] qca-swiss-army-knife: fix .gitignore for initvals
Date: Thu, 28 Jun 2012 02:26:29 +0200
Message-Id: <1340843199-49821-1-git-send-email-nbd@openwrt.org> (sfid-20120628_022653_514304_B0393C1B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do not make git ignore the whole directory

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 .gitignore |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/.gitignore b/.gitignore
index 26b270f..74c35d6 100644
--- a/.gitignore
+++ b/.gitignore
@@ -1,2 +1,2 @@
-initvals
+/tools/initvals/initvals
 *.ini
-- 
1.7.3.2

