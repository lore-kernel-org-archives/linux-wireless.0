Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:38843 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574Ab3LRE22 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 23:28:28 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 04/10] ath9k: Initialize "switchcomspdt" eeprom field explicitly
Date: Wed, 18 Dec 2013 09:53:21 +0530
Message-Id: <1387340607-20045-5-git-send-email-sujith@msujith.org> (sfid-20131218_052901_895431_C53B678B)
In-Reply-To: <1387340607-20045-1-git-send-email-sujith@msujith.org>
References: <1387340607-20045-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index ec317d6..86baa20 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -131,6 +131,7 @@ static const struct ar9300_eeprom ar9300_default = {
 		.thresh62 = 28,
 		.papdRateMaskHt20 = LE32(0x0cf0e0e0),
 		.papdRateMaskHt40 = LE32(0x6cf0e0e0),
+		.switchcomspdt = 0,
 		.xlna_bias_strength = 0,
 		.futureModal = {
 			0, 0, 0, 0, 0, 0, 0,
@@ -333,6 +334,7 @@ static const struct ar9300_eeprom ar9300_default = {
 		.thresh62 = 28,
 		.papdRateMaskHt20 = LE32(0x0c80c080),
 		.papdRateMaskHt40 = LE32(0x0080c080),
+		.switchcomspdt = 0,
 		.xlna_bias_strength = 0,
 		.futureModal = {
 			0, 0, 0, 0, 0, 0, 0,
@@ -707,6 +709,7 @@ static const struct ar9300_eeprom ar9300_x113 = {
 		.thresh62 = 28,
 		.papdRateMaskHt20 = LE32(0x0c80c080),
 		.papdRateMaskHt40 = LE32(0x0080c080),
+		.switchcomspdt = 0,
 		.xlna_bias_strength = 0,
 		.futureModal = {
 			0, 0, 0, 0, 0, 0, 0,
@@ -909,6 +912,7 @@ static const struct ar9300_eeprom ar9300_x113 = {
 		.thresh62 = 28,
 		.papdRateMaskHt20 = LE32(0x0cf0e0e0),
 		.papdRateMaskHt40 = LE32(0x6cf0e0e0),
+		.switchcomspdt = 0,
 		.xlna_bias_strength = 0,
 		.futureModal = {
 			0, 0, 0, 0, 0, 0, 0,
@@ -1284,6 +1288,7 @@ static const struct ar9300_eeprom ar9300_h112 = {
 		.thresh62 = 28,
 		.papdRateMaskHt20 = LE32(0x0c80c080),
 		.papdRateMaskHt40 = LE32(0x0080c080),
+		.switchcomspdt = 0,
 		.xlna_bias_strength = 0,
 		.futureModal = {
 			0, 0, 0, 0, 0, 0, 0,
@@ -1486,6 +1491,7 @@ static const struct ar9300_eeprom ar9300_h112 = {
 		.thresh62 = 28,
 		.papdRateMaskHt20 = LE32(0x0cf0e0e0),
 		.papdRateMaskHt40 = LE32(0x6cf0e0e0),
+		.switchcomspdt = 0,
 		.xlna_bias_strength = 0,
 		.futureModal = {
 			0, 0, 0, 0, 0, 0, 0,
@@ -1861,6 +1867,7 @@ static const struct ar9300_eeprom ar9300_x112 = {
 		.thresh62 = 28,
 		.papdRateMaskHt20 = LE32(0x0c80c080),
 		.papdRateMaskHt40 = LE32(0x0080c080),
+		.switchcomspdt = 0,
 		.xlna_bias_strength = 0,
 		.futureModal = {
 			0, 0, 0, 0, 0, 0, 0,
@@ -2063,6 +2070,7 @@ static const struct ar9300_eeprom ar9300_x112 = {
 		.thresh62 = 28,
 		.papdRateMaskHt20 = LE32(0x0cf0e0e0),
 		.papdRateMaskHt40 = LE32(0x6cf0e0e0),
+		.switchcomspdt = 0,
 		.xlna_bias_strength = 0,
 		.futureModal = {
 			0, 0, 0, 0, 0, 0, 0,
@@ -2437,6 +2445,7 @@ static const struct ar9300_eeprom ar9300_h116 = {
 		.thresh62 = 28,
 		.papdRateMaskHt20 = LE32(0x0c80C080),
 		.papdRateMaskHt40 = LE32(0x0080C080),
+		.switchcomspdt = 0,
 		.xlna_bias_strength = 0,
 		.futureModal = {
 			0, 0, 0, 0, 0, 0, 0,
@@ -2639,6 +2648,7 @@ static const struct ar9300_eeprom ar9300_h116 = {
 		.thresh62 = 28,
 		.papdRateMaskHt20 = LE32(0x0cf0e0e0),
 		.papdRateMaskHt40 = LE32(0x6cf0e0e0),
+		.switchcomspdt = 0,
 		.xlna_bias_strength = 0,
 		.futureModal = {
 			0, 0, 0, 0, 0, 0, 0,
-- 
1.8.5.1

