Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:58311 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752464AbeB1J75 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Feb 2018 04:59:57 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH for-4.16 V2 0/2] brcmfmac: small fixes
Date: Wed, 28 Feb 2018 10:59:44 +0100
Message-Id: <1519811986-25017-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180228_110003_914299_D043AED2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here two small fixes. The first patch fixes a regression introduced in v4.16
and the second fix is result from this discussion [1].

So these patches are intended 4.16 and apply to the master branch of the
wireless-drivers repository.

[1] https://www.spinics.net/lists/linux-wireless/thrd12.html#170494

Arend van Spriel (2):
  brcmfmac: add possibility to obtain firmware error
  brcmfmac: fix P2P_DEVICE ethernet address generation

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h    |  2 ++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c | 10 ++++++++++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c    |  3 +++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c     | 10 +++++-----
 4 files changed, 20 insertions(+), 5 deletions(-)

-- 
1.9.1
