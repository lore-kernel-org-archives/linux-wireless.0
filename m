Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3968 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756930Ab2JJSNW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2012 14:13:22 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/7] miscellaneous fixes intended for 3.7
Date: Wed, 10 Oct 2012 11:13:05 -0700
Message-ID: <1349892792-4792-1-git-send-email-frankyl@broadcom.com> (sfid-20121010_201328_694938_DE817865)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here are some miscellaneous brcmfmac bug fix patches aiming for 3.7

Arend van Spriel (1):
  brcmfmac: remove 'always false' condition from brcmf_c_mkiovar_bsscfg

Dan Carpenter (2):
  brcmfmac: Using zero instead of NULL
  brcmfmac: fix end of loop check (signedness bug)

Franky Lin (3):
  brcmfmac: fix sparse warnings
  brcmfmac: use control channel in roamed status reporting
  brcmfmac: set dongle mode accordingly when interface up

Hante Meuleman (1):
  brcmfmac: handle all exceptions as an error.

 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |    2 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   77 +++++++-------------
 3 files changed, 30 insertions(+), 51 deletions(-)

-- 
1.7.9.5


