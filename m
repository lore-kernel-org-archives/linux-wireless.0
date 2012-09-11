Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2261 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816Ab2IKTRA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2012 15:17:00 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH v3.6 0/2] brcmfmac: few endian fixes
Date: Tue, 11 Sep 2012 21:16:46 +0200
Message-ID: <1347391008-10583-1-git-send-email-arend@broadcom.com> (sfid-20120911_211706_861458_9F9F6997)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These two patches fix endianness issues with firmware that were marked
by Florian Fianelli as stable patches. These are intended for v3.6 and
apply to the wireless tree.

Hante Meuleman (2):
  brcmfmac: fix big endian bug in i-scan.
  brcmfmac: Fix big endian host configuration data.

 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |   26 ++++++++++++--------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    6 +++--
 2 files changed, 20 insertions(+), 12 deletions(-)

-- 
1.7.9.5


