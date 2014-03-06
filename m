Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:34840 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbaCFJQW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2014 04:16:22 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 0/2] brcmfmac: resolve atomic_set_mask() issues
Date: Thu, 6 Mar 2014 10:16:10 +0100
Message-ID: <1394097372-4643-1-git-send-email-arend@broadcom.com> (sfid-20140306_101636_627248_F2CE2E45)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tiny series resolving build issues on several platforms as reported
by Fengguang Wu and Stephen Rothwell.

These patches apply to the master branch of the wireless-next
repository.

Arend van Spriel (1):
  Revert "brcmfmac: Use atomic functions for intstatus update."

Hante Meuleman (1):
  brcmfmac: Use atomic functions for intstatus update.

 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

-- 
1.7.10.4

