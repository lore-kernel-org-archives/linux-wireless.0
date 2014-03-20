Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:20797 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaCTJSK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Mar 2014 05:18:10 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 0/4] brcmfmac: OBSS configuration and other cleanup
Date: Thu, 20 Mar 2014 10:17:59 +0100
Message-ID: <1395307083-31523-1-git-send-email-arend@broadcom.com> (sfid-20140320_101818_771597_9498B613)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hope this series is still in the _now_. Just a couple of small
patches that are ready for the v3.15 stream.

The series applies to the master branch of the wireless-next
repository.

Arend van Spriel (3):
  brcmfmac: reinit watchdog completion after handling watchdog
  brcmfmac: only show error message when brcmf_sdiod_regrw_helper()
    fails
  brcmfmac: fallback to mimo_bw_cap for older firmwares

Daniel Kim (1):
  brcmfmac: Enable 40MHz bandwidth in 2GHz band and OBSS scanning
    operations

 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |   41 ++++++++++----------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    1 +
 .../net/wireless/brcm80211/brcmfmac/fwil_types.h   |   10 +++++
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   36 +++++++++++++++++
 4 files changed, 68 insertions(+), 20 deletions(-)

-- 
1.7.9.5

