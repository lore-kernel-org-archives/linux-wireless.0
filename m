Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:51170 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab3IAHB2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Sep 2013 03:01:28 -0400
Subject: [PATCH v2 0/7] ath10k: pci cleanup
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 01 Sep 2013 10:01:24 +0300
Message-ID: <20130901070020.14695.16694.stgit@localhost6.localdomain6> (sfid-20130901_090144_169532_EF9B15A9)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Small PCI related code cleanup. Depends on Michal's CE
clean patchset.

v2:

o remove unnecessary cast in patch 3 (from Gabor)

---

Kalle Valo (7):
      ath10k: pci: make host_ce_config_wlan[] more readable
      ath10k: make target_ce_config_wlan more readable
      ath10k: remove void pointer from struct ath10k_pci_compl
      ath10k: convert ath10k_pci_reg_read/write32() to take struct ath10k
      ath10k: clean up ath10k_ce_completed_send_next_nolock()
      ath10k: convert ath10k_pci_wake() to return
      ath10k: simplify ath10k_ce_init() wake up handling


 drivers/net/wireless/ath/ath10k/ce.c  |   98 ++++++++++------
 drivers/net/wireless/ath/ath10k/pci.c |  208 ++++++++++++++++++++++++---------
 drivers/net/wireless/ath/ath10k/pci.h |   22 ++-
 3 files changed, 227 insertions(+), 101 deletions(-)

