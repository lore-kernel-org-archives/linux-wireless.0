Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:57354 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179Ab3HUG5f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 02:57:35 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/6] ath10k: CE cleanups
Date: Wed, 21 Aug 2013 08:57:23 +0200
Message-ID: <1377068249-26025-1-git-send-email-michal.kazior@tieto.com> (sfid-20130821_085739_634185_6EDB22E8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This patchset contains non-functional changes
except patch #1 which changes memory allocation
from dynamic to static.

There is still some more to clean up in PCI/CE
but it's probably better to keep patchsets compact
and more frequent.


Pozdrawiam / Best regards,
Michal Kazior.


Michal Kazior (6):
  ath10k: use inline ce_state structure
  ath10k: remove ce_op_state
  ath10k: remove unused ce_attr parameters
  ath10k: rename hif_ce_pipe_info to ath10k_pci_pipe
  ath10k: rename ce_state to ath10k_ce_pipe
  ath10k: rename ce_ring_state to ath10k_ce_ring

 drivers/net/wireless/ath/ath10k/ce.c  |  107 +++++++++++++++------------------
 drivers/net/wireless/ath/ath10k/ce.h  |   56 ++++++-----------
 drivers/net/wireless/ath/ath10k/pci.c |   78 ++++++++++++------------
 drivers/net/wireless/ath/ath10k/pci.h |   17 +++---
 4 files changed, 116 insertions(+), 142 deletions(-)

-- 
1.7.9.5

