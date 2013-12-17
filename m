Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:38429 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab3LQJWq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 04:22:46 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/4] ath9k: Initialize "switchcomspdt" eeprom field explicitly
Date: Tue, 17 Dec 2013 14:47:47 +0530
Message-Id: <1387271869-12780-2-git-send-email-sujith@msujith.org> (sfid-20131217_102251_992655_F5BE3B97)
In-Reply-To: <1387271869-12780-1-git-send-email-sujith@msujith.org>
References: <1387271869-12780-1-git-send-email-sujith@msujith.org>
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

