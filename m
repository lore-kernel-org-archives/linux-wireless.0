Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:16427 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbcFCVbR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2016 17:31:17 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 0/6] brcm80211: contact info update and new devices
Date: Fri,  3 Jun 2016 23:31:06 +0200
Message-Id: <1464989472-29684-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20160603_233132_043382_1ACB812A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series provides:

 * update contact info in MAINTAINERS file.
 * support for BCM43525 and BCM43465 PCIe devices.
 * couple of smallish fixes in SDIO.

The patch series is intended for v4.8 and applies to the master
branch of the wireless-drivers-next repository.

Arend van Spriel (1):
  brcm80211: update maintainers email addresses

Hante Meuleman (2):
  brcmfmac: fix skb priority handling
  brcmfmac: add support for the PCIE devices 43525 and 43465

wrightf (3):
  brcmfmac: revise SDIO error message in brcmf_sdio_drivestrengthinit
  brcmfmac: use ndev->needed_headroom to reserve additional header space
  brcmfmac: change rx_seq check log from error print to debug print

 MAINTAINERS                                                   | 9 ++++-----
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c       | 2 ++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c       | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c   | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c       | 6 +++++-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c       | 5 ++---
 drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h | 2 ++
 7 files changed, 17 insertions(+), 11 deletions(-)

-- 
1.9.1

