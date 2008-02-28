Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ruslug.rutgers.edu ([165.230.139.146]:45282 "EHLO
	ruslug.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759451AbYB1XBF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2008 18:01:05 -0500
Date: Thu, 28 Feb 2008 18:01:01 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: linville@tuxdriver.com
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	jirislaby@gmail.com, mickflemm@gmail.com, bruno@thinktube.com,
	me@bobcopeland.com
Subject: [PATCH 8/8] ath5k: Add RF2413 name to srev_names
Message-ID: <aabf4c57da581c24f33181064d7a21eb5bfd556c.1204236793.git.mcgrof@winlab.rutgers.edu> (sfid-20080228_230111_501741_3C8CE07E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f6d5bb6d43d1ddfb60d5ed8b8d6ee472643eafd8.1204236793.git.mcgrof@winlab.rutgers.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Add 2413 to srev_names so that it shows up during module load

Changes-licensed-under: 3-clause-BSD
Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
---
 drivers/net/wireless/ath5k/base.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 0b743f7..d72dec0 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -118,6 +118,8 @@ static struct ath5k_srev_name srev_names[] = {
 	{ "5212",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR5212 },
 	{ "5213",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR5213 },
 	{ "5213A",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR5213A },
+	{ "2413",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR2413 },
+	{ "2414",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR2414 },
 	{ "2424",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR2424 },
 	{ "5424",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR5424 },
 	{ "5413",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR5413 },
@@ -132,6 +134,7 @@ static struct ath5k_srev_name srev_names[] = {
 	{ "5112A",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_5112A },
 	{ "2112",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_2112 },
 	{ "2112A",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_2112A },
+	{ "SChip",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_SC0 },
 	{ "SChip",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_SC1 },
 	{ "SChip",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_SC2 },
 	{ "5133",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_5133 },
-- 
1.5.3.7

