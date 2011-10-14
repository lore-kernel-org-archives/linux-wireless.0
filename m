Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:32794 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab1JNMww (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Oct 2011 08:52:52 -0400
Received: by ywp31 with SMTP id 31so257185ywp.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 Oct 2011 05:52:52 -0700 (PDT)
From: Sangwook Lee <sangwook.lee@linaro.org>
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, patches@linaro.org,
	Sangwook Lee <sangwook.lee@linaro.org>
Subject: [PATCH 0/5] ath6kl: Add SDIO polling method for debugging 
Date: Fri, 14 Oct 2011 13:50:41 +0100
Message-Id: <1318596646-19495-1-git-send-email-sangwook.lee@linaro.org> (sfid-20111014_145256_656670_7F595329)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add SDIO polling method based user defined intevals
At initial development stage, when SDIO irqs problem happen,
We can use this funtionality for debugging.
This is only tested with AR6003 HW2.0

Sangwook Lee (5):
  ath6kl: Add SDIO polling function definitions
  ath6kl: Add SDIO polling function hook into SDIO init time
  ath6kl: Add SDIO polling method into menu
  ath6kl: Add SDIO polling file into Makefile
  ath6kl: Add SDIO polling function

 drivers/net/wireless/ath/ath6kl/Kconfig     |    8 +
 drivers/net/wireless/ath/ath6kl/Makefile    |    1 +
 drivers/net/wireless/ath/ath6kl/debug.h     |   25 +++
 drivers/net/wireless/ath/ath6kl/sdio.c      |    7 +
 drivers/net/wireless/ath/ath6kl/sdio_poll.c |  216 +++++++++++++++++++++++++++
 5 files changed, 257 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath6kl/sdio_poll.c

-- 
1.7.4.1

