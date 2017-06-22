Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:41333 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752563AbdFVKBJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 06:01:09 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 0/4] brcm80211: general admin and headroom rework
Date: Thu, 22 Jun 2017 11:01:00 +0100
Message-Id: <1498125664-25980-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170622_120114_398402_77D8BCE6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This smallish set contains:
 * rework headroom handling in .start_xmit() callback.
 * add Cypress maintainers for brcm80211.

The series apply to the master branch of the wireless-drivers-next
repository.

Arend van Spriel (4):
  brcmfmac: cleanup kerneldoc for struct brcmf_bus
  brcmfmac: use atomic_t for statistic counter in struct brcmf_bus
  brcmfmac: rework headroom check in .start_xmit()
  MAINTAINERS: add brcm80211 maintainer info from Cypress

 MAINTAINERS                                        |  3 +++
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h | 18 +++++++++++++----
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 23 +++++++++++++++-------
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 13 +++++++-----
 4 files changed, 41 insertions(+), 16 deletions(-)

-- 
1.9.1
