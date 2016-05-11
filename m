Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:33359 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbcEKWHW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2016 18:07:22 -0400
Received: by mail-pa0-f43.google.com with SMTP id xk12so22106147pac.0
        for <linux-wireless@vger.kernel.org>; Wed, 11 May 2016 15:07:22 -0700 (PDT)
From: Christian Daudt <csd@broadcom.com>
To: linux-wireless@vger.kernel.org
Cc: Christian Daudt <csd@broadcom.com>,
	brcm80211-dev-list@broadcom.com,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	Franky Lin <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>
Subject: [PATCH v2 0/2] brcmfmac: fixes for some corner cases
Date: Wed, 11 May 2016 15:06:47 -0700
Message-Id: <1463004409-28885-1-git-send-email-csd@broadcom.com> (sfid-20160512_000726_835277_6742B8AC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A couple of patches against v4.6-rc6 which fix an oops when
handling buggy FW and clear int handler warnings on module unload

Changes from v1:
 - combined the patches into a series since "Fix 'did not remove..."
   depends on "Fix kernel oops..." patch

Christian Daudt (2):
  brcmfmac: Fix kernel oops in failed chip_attach
  brcmfmac: Fix 'did not remove int handler' warning

 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 47 +++++++++++++---------
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |  3 +-
 2 files changed, 30 insertions(+), 20 deletions(-)

-- 
1.9.1

