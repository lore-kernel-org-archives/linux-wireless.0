Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:37517 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751355AbdE3MgK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 May 2017 08:36:10 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [RFT 0/3] brcmfmac: firmware loading rework
Date: Tue, 30 May 2017 13:35:51 +0100
Message-Id: <1496147754-2303-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170530_143614_837858_80C5EE9C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Enric,

Could you please try these patches and let me know if they resolve
the issue for you.

Regards,
Arend

Arend van Spriel (3):
  brcmfmac: add parameter to pass error code in firmware callback
  brcmfmac: use firmware callback upon failure to load
  brcmfmac: unbind all devices upon failure in firmware callback

 .../broadcom/brcm80211/brcmfmac/firmware.c         | 35 +++++++++++-----------
 .../broadcom/brcm80211/brcmfmac/firmware.h         |  4 +--
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    | 17 +++++++----
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 18 +++++++----
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |  6 ++--
 5 files changed, 47 insertions(+), 33 deletions(-)

-- 
1.9.1
