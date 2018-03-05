Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37018 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751288AbeCEG6u (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Mar 2018 01:58:50 -0500
From: Anilkumar Kolli <akolli@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Anilkumar Kolli <akolli@codeaurora.org>
Subject: [PATCH 0/2] FWTEST command support in debugfs
Date: Mon,  5 Mar 2018 12:29:06 +0530
Message-Id: <1520233148-26050-1-git-send-email-akolli@codeaurora.org> (sfid-20180305_075854_232880_8FE836B3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add WMI_FWTEST_CMD support.
This command is used to configure tx parameters

Sathishkumar Muruganandam (2):
  ath10k: Add WMI FWTEST command support
  ath10k: add debugfs support to configure fwtest parameters

 drivers/net/wireless/ath/ath10k/core.h    |    2 +
 drivers/net/wireless/ath/ath10k/debug.c   |   81 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-ops.h |   17 ++++++
 drivers/net/wireless/ath/ath10k/wmi.c     |   23 +++++++-
 drivers/net/wireless/ath/ath10k/wmi.h     |    6 +++
 5 files changed, 128 insertions(+), 1 deletion(-)

-- 
1.7.9.5
