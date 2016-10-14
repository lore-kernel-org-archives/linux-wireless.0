Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54988 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752927AbcJNKS5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Oct 2016 06:18:57 -0400
Subject: [PATCH v2 0/2] ath10k: add VHT160 support
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Date: Fri, 14 Oct 2016 13:18:46 +0300
Message-ID: <20161014101710.5300.21550.stgit@potku.adurom.net> (sfid-20161014_121901_189292_3AB69DA5)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

here's v2 of Sebastian's VHT160 patch.

v2:

* cc linux-wireless

* refactor ath10k_peer_assoc_h_phymode()

* fix two rebase issues

* fix checkpatch warnings

---

Kalle Valo (1):
      ath10k: refactor ath10k_peer_assoc_h_phymode()

Sebastian Gottschall (1):
      ath10k: add VHT160 support


 drivers/net/wireless/ath/ath10k/htt_rx.c  |    7 +++-
 drivers/net/wireless/ath/ath10k/mac.c     |   54 +++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |    1 +
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |    1 +
 drivers/net/wireless/ath/ath10k/wmi.c     |    9 ++++-
 drivers/net/wireless/ath/ath10k/wmi.h     |   27 +++++++++++++--
 6 files changed, 87 insertions(+), 12 deletions(-)
