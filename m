Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:31833 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750950AbdJJGuS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Oct 2017 02:50:18 -0400
From: <mpubbise@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
        Manikanta Pubbisetty <mpubbise@qti.qualcomm.com>
Subject: [PATCH 0/2] ath10k: more on tdls support for 10.4 firmwares
Date: Tue, 10 Oct 2017 12:20:00 +0530
Message-ID: <1507618202-25473-1-git-send-email-mpubbise@qti.qualcomm.com> (sfid-20171010_085022_399159_1F596EAB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Manikanta Pubbisetty <mpubbise@qti.qualcomm.com>

This patchset includes a bug fix and an enhancement of tdls functionality
for 10.4 firmwares.

First patch in this series is a bug fix, second one is an enhancement.

Manikanta Pubbisetty (2):
  ath10k: update tdls teardown state to target
  ath10k: handle tdls peer events

 drivers/net/wireless/ath/ath10k/mac.c |   10 ++++++
 drivers/net/wireless/ath/ath10k/wmi.c |   59 +++++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+)

-- 
1.7.9.5
