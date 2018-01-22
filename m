Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:58067 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750891AbeAVUrB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 15:47:01 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 0/2] brcmfmac: better logging of firmware api errors
Date: Mon, 22 Jan 2018 21:46:38 +0100
Message-Id: <1516654000-25314-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180122_214704_471325_481BC6BF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Two patches intended for v4.16 providing:

* better logging of firmware api errors

These apply to the master branch of the wireless-drivers-next repository.

Arend van Spriel (2):
  brcmfmac: assure bcdc dcmd api does not return value > 0
  brcmfmac: separate firmware errors from i/o errors

 .../wireless/broadcom/brcm80211/brcmfmac/bcdc.c    | 17 +++++++++------
 .../wireless/broadcom/brcm80211/brcmfmac/fwil.c    | 24 +++++++++++++---------
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  | 10 +++++----
 .../wireless/broadcom/brcm80211/brcmfmac/proto.h   | 14 +++++++------
 4 files changed, 39 insertions(+), 26 deletions(-)

-- 
1.9.1
