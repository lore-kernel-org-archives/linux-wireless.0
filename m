Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:43851 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381Ab3H0LJt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 07:09:49 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 0/6] ath10k: CE cleanups
Date: Tue, 27 Aug 2013 13:07:57 +0200
Message-ID: <1377601683-12072-1-git-send-email-michal.kazior@tieto.com> (sfid-20130827_130953_789080_07395AD3)
In-Reply-To: <1377068249-26025-1-git-send-email-michal.kazior@tieto.com>
References: <1377068249-26025-1-git-send-email-michal.kazior@tieto.com>
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

v2:
 * fix checkpatch warning (Kalle)


Michal.


Michal Kazior (6):
  ath10k: use inline ce_state structure
  ath10k: remove ce_op_state
  ath10k: remove unused ce_attr parameters
  ath10k: rename hif_ce_pipe_info to ath10k_pci_pipe
  ath10k: rename ce_state to ath10k_ce_pipe
  ath10k: rename ce_ring_state to ath10k_ce_ring

 drivers/net/wireless/ath/ath10k/ce.c  |  125 +++++++++++++++------------------
 drivers/net/wireless/ath/ath10k/ce.h  |   74 ++++++++-----------
 drivers/net/wireless/ath/ath10k/pci.c |   80 +++++++++++----------
 drivers/net/wireless/ath/ath10k/pci.h |   17 +++--
 4 files changed, 136 insertions(+), 160 deletions(-)

-- 
1.7.9.5

