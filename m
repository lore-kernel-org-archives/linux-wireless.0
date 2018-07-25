Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729335AbeGYVF7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Jul 2018 17:05:59 -0400
Subject: [PATCH v1 3/4] iwlwifi: Remove unnecessary include of
 <linux/pci-aspm.h>
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
Date: Wed, 25 Jul 2018 14:52:48 -0500
Message-ID: <153254836793.92573.16383045269302376209.stgit@bhelgaas-glaptop.roam.corp.google.com> (sfid-20180725_215303_311797_9CE26D4E)
In-Reply-To: <153254813164.92573.10755585465477668768.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <153254813164.92573.10755585465477668768.stgit@bhelgaas-glaptop.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bjorn Helgaas <bhelgaas@google.com>

This part of the iwlwifi driver doesn't need anything provided by
pci-aspm.h, so remove the unnecessary include of it.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 38234bda9017..d6c55e111fda 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -72,7 +72,6 @@
 #include <linux/module.h>
 #include <linux/pm_runtime.h>
 #include <linux/pci.h>
-#include <linux/pci-aspm.h>
 #include <linux/acpi.h>
 
 #include "fw/acpi.h"
