Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:56650 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727586AbeIEMSD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Sep 2018 08:18:03 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH V2 0/2] brcmfmac: fix for 160MHz and firmware capabilities
Date: Wed,  5 Sep 2018 09:48:57 +0200
Message-Id: <1536133739-5693-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180905_094910_791972_0E298D3A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Resending two patches which apply to the master branch of the
wireless-drivers-next repository.

Arend van Spriel (2):
  brcmfmac: fix for proper support of 160MHz bandwidth
  brcmfmac: increase buffer for obtaining firmware capabilities

 .../wireless/broadcom/brcm80211/brcmfmac/feature.c |  2 +-
 .../net/wireless/broadcom/brcm80211/brcmutil/d11.c | 34 +++++++++++++++++++++-
 .../broadcom/brcm80211/include/brcmu_wifi.h        |  2 ++
 3 files changed, 36 insertions(+), 2 deletions(-)

-- 
1.9.1
