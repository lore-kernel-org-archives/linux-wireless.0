Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50423 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232Ab0KNLgm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Nov 2010 06:36:42 -0500
Received: by wwb29 with SMTP id 29so387874wwb.1
        for <linux-wireless@vger.kernel.org>; Sun, 14 Nov 2010 03:36:41 -0800 (PST)
From: Mike Rapoport <mike.rapoport@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Dowan Kim <dowan@broadcom.com>, linux-wireless@vger.kernel.org,
	Mike Rapoport <mike.rapoport@gmail.com>
Subject: [PATCH 0/4] staging: brcm80211: misc cleanups
Date: Sun, 14 Nov 2010 13:36:20 +0200
Message-Id: <cover.1289734125.git.mike.rapoport@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches remove some unused declarations in include/linux_osl.h
and unused bindings to SDIO controller devices in brcmfmac driver

Mike Rapoport (4):
  staging: brcm80211: remove unused osl_pkt{get,free}_static
  staging: brcm80211: brcmfmac: remove PCI SDIO controller binding
  staging: brcm80211: brcmfmac: remove PXA SDIO controller binding
  staging: brcm80211: brcmfmac: cleanup bcmsdh_(un)register

 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c |  259 +--------------------
 drivers/staging/brcm80211/include/linux_osl.h     |    3 -
 2 files changed, 1 insertions(+), 261 deletions(-)

