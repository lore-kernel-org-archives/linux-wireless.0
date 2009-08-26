Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:13448 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756583AbZHZDJS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2009 23:09:18 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2009 20:09:21 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19092.42883.522031.152175@gargle.gargle.HOWL>
Date: Wed, 26 Aug 2009 08:39:55 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 4/4] ath9k: Update INITVALs for AR9285
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/initvals.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/initvals.h b/drivers/net/wireless/ath/ath9k/initvals.h
index 27a86bb..8622265 100644
--- a/drivers/net/wireless/ath/ath9k/initvals.h
+++ b/drivers/net/wireless/ath/ath9k/initvals.h
@@ -4133,7 +4133,7 @@ static const u_int32_t ar9285Modes_9285_1_2[][6] = {
     { 0x00008318, 0x00003e80, 0x00007d00, 0x00006880, 0x00003440, 0x00006880 },
     { 0x00009804, 0x00000300, 0x000003c4, 0x000003c4, 0x00000300, 0x00000303 },
     { 0x00009820, 0x02020200, 0x02020200, 0x02020200, 0x02020200, 0x02020200 },
-    { 0x00009824, 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e },
+    { 0x00009824, 0x01000e0e, 0x01000e0e, 0x01000e0e, 0x01000e0e, 0x01000e0e },
     { 0x00009828, 0x0a020001, 0x0a020001, 0x0a020001, 0x0a020001, 0x0a020001 },
     { 0x00009834, 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e },
     { 0x00009838, 0x00000007, 0x00000007, 0x00000007, 0x00000007, 0x00000007 },
@@ -4158,7 +4158,7 @@ static const u_int32_t ar9285Modes_9285_1_2[][6] = {
     { 0x000099bc, 0x00000600, 0x00000600, 0x00000c00, 0x00000c00, 0x00000c00 },
     { 0x000099c0, 0x05eea6d4, 0x05eea6d4, 0x05eea6d4, 0x05eea6d4, 0x05eea6d4 },
     { 0x000099c4, 0x06336f77, 0x06336f77, 0x06336f77, 0x06336f77, 0x06336f77 },
-    { 0x000099c8, 0x6af65329, 0x6af65329, 0x6af65329, 0x6af65329, 0x6af65329 },
+    { 0x000099c8, 0x6af6532f, 0x6af6532f, 0x6af6532f, 0x6af6532f, 0x6af6532f },
     { 0x000099cc, 0x08f186c8, 0x08f186c8, 0x08f186c8, 0x08f186c8, 0x08f186c8 },
     { 0x000099d0, 0x00046384, 0x00046384, 0x00046384, 0x00046384, 0x00046384 },
     { 0x000099d4, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 },
@@ -4601,7 +4601,7 @@ static const u_int32_t ar9285Common_9285_1_2[][2] = {
     { 0x00008258, 0x00000000 },
     { 0x0000825c, 0x400000ff },
     { 0x00008260, 0x00080922 },
-    { 0x00008264, 0xa8a00010 },
+    { 0x00008264, 0x88a00010 },
     { 0x00008270, 0x00000000 },
     { 0x00008274, 0x40000000 },
     { 0x00008278, 0x003e4180 },
@@ -4650,7 +4650,7 @@ static const u_int32_t ar9285Common_9285_1_2[][2] = {
     { 0x00009954, 0x5f3ca3de },
     { 0x00009958, 0x2108ecff },
     { 0x00009968, 0x000003ce },
-    { 0x00009970, 0x192bb515 },
+    { 0x00009970, 0x192bb514 },
     { 0x00009974, 0x00000000 },
     { 0x00009978, 0x00000001 },
     { 0x0000997c, 0x00000000 },
@@ -4728,7 +4728,7 @@ static const u_int32_t ar9285Common_9285_1_2[][2] = {
     { 0x00007800, 0x00140000 },
     { 0x00007804, 0x0e4548d8 },
     { 0x00007808, 0x54214514 },
-    { 0x0000780c, 0x02025820 },
+    { 0x0000780c, 0x02025830 },
     { 0x00007810, 0x71c0d388 },
     { 0x00007814, 0x924934a8 },
     { 0x0000781c, 0x00000000 },
-- 
1.6.4

