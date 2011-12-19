Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:34052 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325Ab1LSVZY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 16:25:24 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: Rodriguez Luis <rodrigue@qca.qualcomm.com>
Cc: mcgrof@infradead.org, linux-wireless@vger.kernel.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 08/15] initvals: remove unused variable
Date: Mon, 19 Dec 2011 22:24:53 +0100
Message-Id: <1324329900-3923-9-git-send-email-juhosg@openwrt.org> (sfid-20111219_222539_483609_A520261B)
In-Reply-To: <1324329900-3923-1-git-send-email-juhosg@openwrt.org>
References: <1324329900-3923-1-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch fixes the following warning
(with CFLAGS=-Wunused):

initvals.c: In function ‘ath9k_hw_print_initval’:
initvals.c:315: warning: unused variable ‘chksum’

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 initvals.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/initvals.c b/initvals.c
index c9235d2..a12573a 100644
--- a/initvals.c
+++ b/initvals.c
@@ -312,7 +312,7 @@ static u32 ath9k_patch_initval(u32 idx, u32 val)
 
 static void ath9k_hw_print_initval(const u32 *array, u32 rows, u32 columns, bool onedim)
 {
-	u32 chksum, col, row;
+	u32 col, row;
 
 	/*
 	 * This checksum stuff is designed for columns <= 8),
-- 
1.7.2.1

