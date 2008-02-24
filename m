Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:40396 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753688AbYBXEdg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Feb 2008 23:33:36 -0500
Date: Sun, 24 Feb 2008 06:33:19 +0200
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, bruno@thinktube.com, jirislaby@gmail.com,
	mcgrof@gmail.com
Subject: [PATCH 8/8] ath5k: Add RF2413 name to srev_names
Message-ID: <20080224043319.GG4426@makis.domain.invalid> (sfid-20080224_043339_220903_BC31C932)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


 * Add 2413 to srev_names so that it shows up during module load


Changes-licensed-under: 3-clause-BSD
Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

---
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


