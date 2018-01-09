Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:56582 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752045AbeAIMXC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Jan 2018 07:23:02 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH V2 0/3] brcmfmac: restructuring sdio access functions - final drop (take 2)
Date: Tue,  9 Jan 2018 13:22:51 +0100
Message-Id: <1515500574-16321-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180109_132307_077878_EDDA0AB1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Resending remaining patch of the series, which have been rebased on the
master branch of wireless-drivers-next.

Arend van Spriel (3):
  brcmfmac: Remove array of functions
  brcmfmac: add comment block in brcmf_sdio_buscore_read()
  brcmfmac: rename brcmf_sdiod_buff_{read,write}() functions

 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 149 +++++++++---------
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 175 +++++++++++----------
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |  15 +-
 3 files changed, 170 insertions(+), 169 deletions(-)

--
1.9.1
