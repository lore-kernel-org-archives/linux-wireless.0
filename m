Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3435 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933053Ab3DBTGh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Apr 2013 15:06:37 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH for-3.9 0/4] brcmfmac: fix several driver issues
Date: Tue, 2 Apr 2013 21:06:16 +0200
Message-ID: <1364929580-6206-1-git-send-email-arend@broadcom.com> (sfid-20130402_210650_462928_486F1B3D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This modest number of patches fixes issues found during testing of
AP mode that were introduced couple of kernel releases back. Better
fixing it late than never. Even more so for the download fix.

This series is intended for v3.9 kernel. The patches apply to the master
branch in the wireless repository.

Franky Lin (1):
  brcmfmac: do not proceed if fail to download nvram to dongle

Hante Meuleman (3):
  brcmfmac: fix tkip mic tx/rx ap swap bug.
  brcmfmac: fix stopping AP.
  brcmfmac: fix returning cipher_suite for get_key operation.

 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    6 +--
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   46 +++++++++++---------
 2 files changed, 28 insertions(+), 24 deletions(-)

-- 
1.7.10.4


