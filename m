Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from n10.bullet.re3.yahoo.com ([68.142.237.123]:40757 "HELO
	n10.bullet.re3.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752710AbYDCKWh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 06:22:37 -0400
Message-ID: <47F4AFE8.4020405@yahoo.it> (sfid-20080403_112241_062311_EBEDB022)
Date: Thu, 03 Apr 2008 12:22:32 +0200
From: Filippo Zangheri <filippo.zangheri@yahoo.it>
MIME-Version: 1.0
To: ipw3945-devel@lists.sourceforge.net
CC: linux-wireless@vger.kernel.org,
	"Chatre, Reinette" <reinette.chatre@intel.com>
Subject: [PATCH] iwlwifi: add missing include in iwl-3945-led.c
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iwl-3945-led.c does not include a relevant file.

Signed-off-by: Filippo Zangheri <filippo.zangheri@yahoo.it>
---
 drivers/net/wireless/iwlwifi/iwl-3945-led.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.c b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
index d200d08..7743cac 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
@@ -40,6 +40,7 @@
 #include <asm/unaligned.h>
 
 #include "iwl-3945.h"
+#include "iwl-3945-led.h"
 #include "iwl-helpers.h"
 
 #define IWL_1MB_RATE (128 * 1024)

-- 
Filippo Zangheri

GPG key ID: 0xE1D879FA
Key fingerprint: 816B CE57 D43C 0A47 EF35 3378 EA5F A72A E1D8 79FA
Key server: pgp.mit.edu

-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GE d- s+:- a-- C++ UL+++ P+ L+++ E-- W+ N* o-- K- w--- O-- M--
V- PS++ PE+ Y+ PGP++ t 5-- X++ R* tv b+ DI-- D---- G-- e++ h--
r++ z*
------END GEEK CODE BLOCK------

