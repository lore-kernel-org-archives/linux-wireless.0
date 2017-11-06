Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:45235 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751815AbdKFIJ4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Nov 2017 03:09:56 -0500
From: <mpubbise@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
        Manikanta Pubbisetty <mpubbise@qti.qualcomm.com>
Subject: [PATCHv2 0/2] ath10k: more on tdls support for 10.4 firmwares
Date: Mon, 6 Nov 2017 13:39:30 +0530
Message-ID: <1509955772-4941-1-git-send-email-mpubbise@qti.qualcomm.com> (sfid-20171106_091002_234072_F10A3DFF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Manikanta Pubbisetty <mpubbise@qti.qualcomm.com>

This patchset includes a bug fix and an enhancement of tdls functionality for 10.4 firmwares.

First patch in this series is a bug fix, second one is an enhancement.

Manikanta Pubbisetty (2):
  ath10k: update tdls teardown state to target
  ath10k: handle tdls peer events

v2:
  - Corrected the warnings reported by ath10k-check

 drivers/net/wireless/ath/ath10k/mac.c |   10 +++++
 drivers/net/wireless/ath/ath10k/wmi.c |   72 +++++++++++++++++++++++++++++++++
 2 files changed, 82 insertions(+)

-- 
1.7.9.5
