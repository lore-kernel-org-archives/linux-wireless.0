Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42211 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965557AbcCJKNF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2016 05:13:05 -0500
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH 0/3] ath10k: add calibration data download support for qca4019
Date: Thu, 10 Mar 2016 15:42:35 +0530
Message-ID: <1457604758-14454-1-git-send-email-rmani@qti.qualcomm.com> (sfid-20160310_111316_492346_BD261D2D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The necessary update in dt binding doc
(Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt) is done
in below patch and it's posted separately,
  
  "dt: bindings: add new dt entry for pre calibration in qcom,ath10k.txt"

Raja Mani (3):
  ath10k: pass cal data location as an argument to
    ath10k_download_cal_{file|dt}
  ath10k: move cal data len to hw_params
  ath10k: incorporate qca4019 cal data download sequence

 drivers/net/wireless/ath/ath10k/core.c  | 120 ++++++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath10k/core.h  |  12 +++-
 drivers/net/wireless/ath/ath10k/debug.c |   7 +-
 drivers/net/wireless/ath/ath10k/hw.h    |   2 -
 4 files changed, 120 insertions(+), 21 deletions(-)

-- 
1.8.1.2

