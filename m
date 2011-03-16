Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38405 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102Ab1CPAPy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 20:15:54 -0400
Date: Tue, 15 Mar 2011 20:12:34 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: wireless-2.6 2011-03-15
Message-ID: <20110316001234.GA28663@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dave,

I nearly forgot this one!  It is a really simple patch to enable the use
of some (so far still unreleased) firmware for the iwl1000 hardware.

Please pull for 2.6.39-rc1, so that users will be able to use the
new firmware when it is generally available!

John

---

The following changes since commit 84c0c6933cb0303fa006992a6659c2b46de4eb17:

  smsc911x: Fix build error when SMSC_TRACE() used (2011-03-15 14:52:48 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git master

Fry, Donald H (1):
      iwlagn: Support new 1000 microcode.

 drivers/net/wireless/iwlwifi/iwl-1000.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index ba78bc8..507cab4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -49,7 +49,7 @@
 #include "iwl-agn-debugfs.h"
 
 /* Highest firmware API version supported */
-#define IWL1000_UCODE_API_MAX 3
+#define IWL1000_UCODE_API_MAX 5
 #define IWL100_UCODE_API_MAX 5
 
 /* Lowest firmware API version supported */
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
