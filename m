Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:30910 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751389AbdLULO7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Dec 2017 06:14:59 -0500
From: Rakesh Pillai <pillair@qti.qualcomm.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@qti.qualcomm.com>
Subject: [PATCH 0/3] Core changes for wcn3990
Date: Thu, 21 Dec 2017 16:44:44 +0530
Message-Id: <1513854887-10759-1-git-send-email-pillair@qti.qualcomm.com> (sfid-20171221_121503_701996_74A8839B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset includes the core changes for wcn3990 to
- Add SNOC bus type used for wcn3990 target
- Add the debug mask for SNOC bus type
- Adding fw feature flag for non-bmi firmware load, since wcn3990
  firmware is not loaded by bmi

Govind Singh (2):
  ath10k: Add SNOC bus type for WCN3990 target
  ath10k: Add debug mask for SNOC bus type

Rakesh Pillai (1):
  ath10k: Add fw feature flag for non-bmi firmware load

 drivers/net/wireless/ath/ath10k/core.c  | 175 +++++++++++++++++++-------------
 drivers/net/wireless/ath/ath10k/core.h  |   6 ++
 drivers/net/wireless/ath/ath10k/debug.h |   1 +
 3 files changed, 110 insertions(+), 72 deletions(-)

-- 
2.11.0
