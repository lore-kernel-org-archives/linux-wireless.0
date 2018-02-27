Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:60119 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751635AbeB0Xma (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 18:42:30 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH for-4.16 0/2] brcmfmac: small fixes
Date: Wed, 28 Feb 2018 00:42:18 +0100
Message-Id: <1519774940-20793-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180228_004235_502171_EF78F160)
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
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c |  2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c    |  1 +
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c     | 10 +++++-----
 4 files changed, 9 insertions(+), 6 deletions(-)

-- 
1.9.1
