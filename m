Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:16129 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532Ab1G0C1H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2011 22:27:07 -0400
Subject: [PATCH 1/3] ath: fix spelling of Grenada
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Tue, 26 Jul 2011 22:26:52 -0400
Message-ID: <20110727022652.27981.27951.stgit@mj.roinet.com> (sfid-20110727_042714_360893_BA2A9D92)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/ath/regd.h        |    2 +-
 drivers/net/wireless/ath/regd_common.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/regd.h b/drivers/net/wireless/ath/regd.h
index 172f63f..03a8268 100644
--- a/drivers/net/wireless/ath/regd.h
+++ b/drivers/net/wireless/ath/regd.h
@@ -101,7 +101,7 @@ enum CountryCode {
 	CTRY_GERMANY = 276,
 	CTRY_GREECE = 300,
 	CTRY_GREENLAND = 304,
-	CTRY_GRENEDA = 308,
+	CTRY_GRENADA = 308,
 	CTRY_GUAM = 316,
 	CTRY_GUATEMALA = 320,
 	CTRY_HAITI = 332,
diff --git a/drivers/net/wireless/ath/regd_common.h b/drivers/net/wireless/ath/regd_common.h
index 24b5383..bdd2b4d 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -332,7 +332,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_GERMANY, ETSI1_WORLD, "DE"},
 	{CTRY_GREECE, ETSI1_WORLD, "GR"},
 	{CTRY_GREENLAND, ETSI1_WORLD, "GL"},
-	{CTRY_GRENEDA, FCC3_FCCA, "GD"},
+	{CTRY_GRENADA, FCC3_FCCA, "GD"},
 	{CTRY_GUAM, FCC1_FCCA, "GU"},
 	{CTRY_GUATEMALA, FCC1_FCCA, "GT"},
 	{CTRY_HAITI, ETSI1_WORLD, "HT"},
