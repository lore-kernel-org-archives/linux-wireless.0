Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:56087 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627Ab3H3MaE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Aug 2013 08:30:04 -0400
Subject: [PATCH 0/7] ath10k: pci cleanup
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 30 Aug 2013 15:29:59 +0300
Message-ID: <20130830122905.31164.50662.stgit@localhost6.localdomain6> (sfid-20130830_143008_360080_319B8283)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Small PCI related code cleanup. Depends on Michal's CE
clean patchset.

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

