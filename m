Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:43761 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752883AbdLHMKn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Dec 2017 07:10:43 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 00/10] brcmfmac: restructuring sdio access functions - take 2
Date: Fri,  8 Dec 2017 13:10:25 +0100
Message-Id: <1512735035-342-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20171208_131055_365504_78984A96)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here another series of patches which were originally submitted by
Ian Molton. For some patches I reworded the commit message.

The series is intended for 4.16 and applies to the master branch of
the wireless-drivers-next repository.

Ian Molton (10):
  brcmfmac: Split brcmf_sdiod_buffrw function up.
  brcmfmac: whitespace fixes in brcmf_sdiod_send_buf()
  brcmfmac: Clarify if using braces.
  brcmfmac: Rename / replace old IO functions with simpler ones.
  brcmfmac: Tidy register definitions a little
  brcmfmac: Remove brcmf_sdiod_addrprep()
  brcmfmac: remove unnecessary call to
    brcmf_sdiod_set_backplane_window()
  brcmfmac: Cleanup offsetof()
  brcmfmac: Remove unused macro.
  brcmfmac: Remove repeated calls to brcmf_chip_get_core()

 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 313 ++++++++-------------
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 248 ++++++++--------
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |  47 ++--
 3 files changed, 263 insertions(+), 345 deletions(-)

-- 
1.9.1
