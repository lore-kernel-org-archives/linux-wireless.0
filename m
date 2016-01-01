Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:55443 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbcAASV2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jan 2016 13:21:28 -0500
Subject: [PATCH 0/2] net-ath9k_htc: Fine-tuning for two function
 implementations
References: <566ABCD9.1060404@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	Kalle Valo <kvalo@codeaurora.org>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <5686C390.5060600@users.sourceforge.net> (sfid-20160101_192207_666150_99A85182)
Date: Fri, 1 Jan 2016 19:21:04 +0100
MIME-Version: 1.0
In-Reply-To: <566ABCD9.1060404@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 1 Jan 2016 19:16:05 +0100

A few update suggestions were taken into account
from static source code analysis.

Markus Elfring (2):
  Delete an unnecessary variable initialisation in ath9k_hif_usb_rx_stream()
  Replace a variable initialisation by an assignment in ath9k_htc_set_channel()

 drivers/net/wireless/ath/ath9k/hif_usb.c      | 2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c | 7 ++-----
 2 files changed, 3 insertions(+), 6 deletions(-)

-- 
2.6.3

