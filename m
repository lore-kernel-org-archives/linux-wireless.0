Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:44235 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030525Ab3HIINl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Aug 2013 04:13:41 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/3] ath10k: firmware-related updates
Date: Fri, 9 Aug 2013 10:13:31 +0200
Message-ID: <1376036014-29707-1-git-send-email-michal.kazior@tieto.com> (sfid-20130809_101348_056259_10D30798)
In-Reply-To: <1375949298-7159-1-git-send-email-michal.kazior@tieto.com>
References: <1375949298-7159-1-git-send-email-michal.kazior@tieto.com>
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

This includes fixes for issues pointed out during
RFC review.


Pozdrawiam / Best regards,
Michal Kazior.


Michal Kazior (3):
  ath10k: clean up HTT tx tid handling
  ath10k: add support for firmware newer than 636
  ath10k: add support for HTT 3.0

 drivers/net/wireless/ath/ath10k/core.h   |   10 ++++
 drivers/net/wireless/ath/ath10k/htt.c    |   19 +++-----
 drivers/net/wireless/ath/ath10k/htt.h    |   12 +++--
 drivers/net/wireless/ath/ath10k/htt_tx.c |   74 +++++++++++++++++++++---------
 drivers/net/wireless/ath/ath10k/hw.h     |    3 ++
 drivers/net/wireless/ath/ath10k/mac.c    |   18 ++++++--
 drivers/net/wireless/ath/ath10k/wmi.c    |   32 +++++++++----
 drivers/net/wireless/ath/ath10k/wmi.h    |   16 +++++--
 8 files changed, 131 insertions(+), 53 deletions(-)

-- 
1.7.9.5

