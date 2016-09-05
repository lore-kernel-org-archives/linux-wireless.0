Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:6671 "EHLO
        mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933270AbcIEKmT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Sep 2016 06:42:19 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 0/2] brcmfmac: bcm4339 and small fix
Date: Mon,  5 Sep 2016 11:42:11 +0100
Message-Id: <1473072133-4266-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20160905_124227_379101_AD07A3C9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains two small changes:
- add modalias for bcm4339 chip.
- abort retries upon sdio access failure.

Arend van Spriel (2):
  brcmfmac: add support for bcm4339 chip with modalias
    sdio:c00v02D0d4339
  brcmfmac: sdio: shorten retry loop in brcmf_sdio_kso_control()

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c |  1 +
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c   | 14 +++++++++++---
 include/linux/mmc/sdio_ids.h                              |  1 +
 3 files changed, 13 insertions(+), 3 deletions(-)

-- 
1.9.1
