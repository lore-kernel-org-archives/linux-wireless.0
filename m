Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:36137 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbbFOUsp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2015 16:48:45 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 0/2] brcmfmac: fix two regressions
Date: Mon, 15 Jun 2015 22:48:37 +0200
Message-ID: <1434401319-16136-1-git-send-email-arend@broadcom.com> (sfid-20150615_224850_439979_AFB7763B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here two patches that:

* fix regressions introduced in earlier v4.2 patches.

It applies to the master branch of wireless-drivers-next repository.

Arend van Spriel (2):
  brcmfmac: fix double free of p2pdev interface
  brcmfmac: make brcmf_p2p_detach() call conditional

 drivers/net/wireless/brcm80211/brcmfmac/core.c | 3 ++-
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c  | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

-- 
1.9.1

