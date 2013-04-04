Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4579 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758093Ab3DDKK3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Apr 2013 06:10:29 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH for-3.9 0/2] brcm80211: fixes for v3.9 kernel
Date: Thu, 4 Apr 2013 12:10:09 +0200
Message-ID: <1365070211-26308-1-git-send-email-arend@broadcom.com> (sfid-20130404_121033_833926_621C02E9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The brcmsmac patch was previous submitted, but had compilation
issues after rebase. This attempt has been through compilation
testing after rebase.

The brcmfmac patch is to disable P2P_DEVICE support as discussed
earlier on the linux-wireless list.

Both patches are intended for v3.9 kernel and apply (and build)
to the master branch of the wireless repository.

Arend van Spriel (2):
  brcmsmac: request firmware in .start() callback
  brcmfmac: remove advertising P2P device support

 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    7 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |  264 ++++++++++----------
 2 files changed, 133 insertions(+), 138 deletions(-)

-- 
1.7.10.4


