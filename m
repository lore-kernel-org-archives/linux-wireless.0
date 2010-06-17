Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34096 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932805Ab0FQJsA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jun 2010 05:48:00 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 17 Jun 2010 02:48:00 -0700
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath: Update the regulatory domain information for a few countries.
Date: Thu, 17 Jun 2010 15:17:52 +0530
Message-ID: <1276768074-4366-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add Kenya(KE) with APL1_WORLD.
Change Honduras(HN) to FCC3_WORLD.
Change Lebanon(LB) to  APL1_WORLD,
Change Macedonia(MK) to ETSI1_WORLD.
Change Pakistan(PK) to APL1_WORLD.
Change Romania(RO) to ETSI1_WORLD.
Change Russia(RU) to FCC3_WORLD.
Change Saudi Arabia(SA) to FCC2_WORLD.
Change UAE(AE) to ETSI1_WORLD.
Change Venezuela(VE) to FCC1_WORLD.
Change Vietnam(VN) to ETSI3_WORLD.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/regd_common.h |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/regd_common.h b/drivers/net/wireless/ath/regd_common.h
index 248c670..b59b690 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -333,7 +333,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_GUAM, FCC1_FCCA, "GU"},
 	{CTRY_GUATEMALA, FCC1_FCCA, "GT"},
 	{CTRY_HAITI, ETSI1_WORLD, "HT"},
-	{CTRY_HONDURAS, NULL1_WORLD, "HN"},
+	{CTRY_HONDURAS, FCC3_WORLD, "HN"},
 	{CTRY_HONG_KONG, FCC3_WORLD, "HK"},
 	{CTRY_HUNGARY, ETSI1_WORLD, "HU"},
 	{CTRY_ICELAND, ETSI1_WORLD, "IS"},
@@ -406,18 +406,19 @@ static struct country_code_to_enum_rd allCountries[] = {
 
 	{CTRY_JORDAN, ETSI2_WORLD, "JO"},
 	{CTRY_KAZAKHSTAN, NULL1_WORLD, "KZ"},
+	{CTRY_KENYA, APL1_WORLD, "KE"},
 	{CTRY_KOREA_NORTH, APL9_WORLD, "KP"},
 	{CTRY_KOREA_ROC, APL9_WORLD, "KR"},
 	{CTRY_KOREA_ROC2, APL2_WORLD, "K2"},
 	{CTRY_KOREA_ROC3, APL9_WORLD, "K3"},
 	{CTRY_KUWAIT, ETSI3_WORLD, "KW"},
 	{CTRY_LATVIA, ETSI1_WORLD, "LV"},
-	{CTRY_LEBANON, NULL1_WORLD, "LB"},
+	{CTRY_LEBANON, APL1_WORLD, "LB"},
 	{CTRY_LIECHTENSTEIN, ETSI1_WORLD, "LI"},
 	{CTRY_LITHUANIA, ETSI1_WORLD, "LT"},
 	{CTRY_LUXEMBOURG, ETSI1_WORLD, "LU"},
 	{CTRY_MACAU, FCC2_WORLD, "MO"},
-	{CTRY_MACEDONIA, NULL1_WORLD, "MK"},
+	{CTRY_MACEDONIA, ETSI1_WORLD, "MK"},
 	{CTRY_MALAYSIA, APL8_WORLD, "MY"},
 	{CTRY_MALTA, ETSI1_WORLD, "MT"},
 	{CTRY_MEXICO, FCC1_FCCA, "MX"},
@@ -429,7 +430,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_NEW_ZEALAND, FCC2_ETSIC, "NZ"},
 	{CTRY_NORWAY, ETSI1_WORLD, "NO"},
 	{CTRY_OMAN, FCC3_WORLD, "OM"},
-	{CTRY_PAKISTAN, NULL1_WORLD, "PK"},
+	{CTRY_PAKISTAN, APL1_WORLD, "PK"},
 	{CTRY_PANAMA, FCC1_FCCA, "PA"},
 	{CTRY_PAPUA_NEW_GUINEA, FCC1_WORLD, "PG"},
 	{CTRY_PERU, APL1_WORLD, "PE"},
@@ -438,9 +439,9 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_PORTUGAL, ETSI1_WORLD, "PT"},
 	{CTRY_PUERTO_RICO, FCC1_FCCA, "PR"},
 	{CTRY_QATAR, APL1_WORLD, "QA"},
-	{CTRY_ROMANIA, NULL1_WORLD, "RO"},
-	{CTRY_RUSSIA, NULL1_WORLD, "RU"},
-	{CTRY_SAUDI_ARABIA, NULL1_WORLD, "SA"},
+	{CTRY_ROMANIA, ETSI1_WORLD, "RO"},
+	{CTRY_RUSSIA, FCC3_WORLD, "RU"},
+	{CTRY_SAUDI_ARABIA, FCC2_WORLD, "SA"},
 	{CTRY_SERBIA_MONTENEGRO, ETSI1_WORLD, "CS"},
 	{CTRY_SINGAPORE, APL6_WORLD, "SG"},
 	{CTRY_SLOVAKIA, ETSI1_WORLD, "SK"},
@@ -457,7 +458,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_TUNISIA, ETSI3_WORLD, "TN"},
 	{CTRY_TURKEY, ETSI3_WORLD, "TR"},
 	{CTRY_UKRAINE, NULL1_WORLD, "UA"},
-	{CTRY_UAE, NULL1_WORLD, "AE"},
+	{CTRY_UAE, ETSI1_WORLD, "AE"},
 	{CTRY_UNITED_KINGDOM, ETSI1_WORLD, "GB"},
 	{CTRY_UNITED_STATES, FCC3_FCCA, "US"},
 	/* This "PS" is for US public safety actually... to support this we
@@ -466,8 +467,8 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_UNITED_STATES_FCC49, FCC4_FCCA, "PS"},
 	{CTRY_URUGUAY, FCC3_WORLD, "UY"},
 	{CTRY_UZBEKISTAN, FCC3_FCCA, "UZ"},
-	{CTRY_VENEZUELA, APL2_ETSIC, "VE"},
-	{CTRY_VIET_NAM, NULL1_WORLD, "VN"},
+	{CTRY_VENEZUELA, FCC1_WORLD, "VE"},
+	{CTRY_VIET_NAM, ETSI3_WORLD, "VN"},
 	{CTRY_YEMEN, NULL1_WORLD, "YE"},
 	{CTRY_ZIMBABWE, NULL1_WORLD, "ZW"},
 };
-- 
1.6.3.3

