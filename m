Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:45066 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbbJAKum (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2015 06:50:42 -0400
Subject: [PATCH 0/6] ath10k: few checkpatch fixes
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 01 Oct 2015 13:50:38 +0300
Message-ID: <20151001105001.8770.96252.stgit@potku.adurom.net> (sfid-20151001_125044_968090_0344FFF8)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I found few checkpatch warnings and fixed those. All trivial.

---

Kalle Valo (6):
      ath10k: fix checkpatch warning about logical continuations
      ath10k: indentation fixes
      ath10k: brace style fixes
      ath10k: remove void function return statements
      ath10k: fix whitespace usage
      ath10k: split an unnecessary long line


 drivers/net/wireless/ath/ath10k/core.c   |   15 +++++++--------
 drivers/net/wireless/ath/ath10k/htt_tx.c |    8 ++++----
 drivers/net/wireless/ath/ath10k/mac.c    |   16 +++++++++-------
 drivers/net/wireless/ath/ath10k/pci.c    |    3 ++-
 drivers/net/wireless/ath/ath10k/wmi.c    |    4 +---
 5 files changed, 23 insertions(+), 23 deletions(-)

