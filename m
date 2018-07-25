Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729904AbeGYVFn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Jul 2018 17:05:43 -0400
Subject: [PATCH v1 1/4] igb: Remove unnecessary include of <linux/pci-aspm.h>
From: Bjorn Helgaas <helgaas@kernel.org>
To: linux-pci@vger.kernel.org
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        ath9k-devel@qca.qualcomm.com, linuxwifi@intel.com,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Wed, 25 Jul 2018 14:52:23 -0500
Message-ID: <153254834342.92573.16877025672192312745.stgit@bhelgaas-glaptop.roam.corp.google.com> (sfid-20180725_215248_514221_E34CD2FB)
In-Reply-To: <153254813164.92573.10755585465477668768.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <153254813164.92573.10755585465477668768.stgit@bhelgaas-glaptop.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bjorn Helgaas <bhelgaas@google.com>

The igb driver doesn't need anything provided by pci-aspm.h, so remove
the unnecessary include of it.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index f707709969ac..c77fda05f683 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -22,7 +22,6 @@
 #include <linux/if.h>
 #include <linux/if_vlan.h>
 #include <linux/pci.h>
-#include <linux/pci-aspm.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/ip.h>
