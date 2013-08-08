Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:56025 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933776Ab3HHIIY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Aug 2013 04:08:24 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 0/3] ath10k: firmware-related updates
Date: Thu, 8 Aug 2013 10:08:15 +0200
Message-ID: <1375949298-7159-1-git-send-email-michal.kazior@tieto.com> (sfid-20130808_100835_557051_AC6BF1D7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This patchset contains 2 firmware-related upgrades
and 1 fix (that I though is a good pick to include
here, since it's related with HTT tx).

This keeps backward compatbility with old
firmware.


Pozdrawiam / Best regards,
Michal Kazior.


Michal Kazior (3):
  ath10k: add support for firmware newer than 636
  ath10k: clean up HTT tx tid handling
  ath10k: add support for HTT 3.0

 drivers/net/wireless/ath/ath10k/htt.c    |   16 +++----
 drivers/net/wireless/ath/ath10k/htt.h    |   12 ++---
 drivers/net/wireless/ath/ath10k/htt_tx.c |   70 ++++++++++++++++++++----------
 drivers/net/wireless/ath/ath10k/hw.h     |    3 ++
 drivers/net/wireless/ath/ath10k/mac.c    |   17 ++++++--
 drivers/net/wireless/ath/ath10k/wmi.c    |   29 +++++++++----
 drivers/net/wireless/ath/ath10k/wmi.h    |   16 +++++--
 7 files changed, 111 insertions(+), 52 deletions(-)

-- 
1.7.9.5

