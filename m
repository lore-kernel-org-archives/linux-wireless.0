Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:44735 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab2GVQvQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jul 2012 12:51:16 -0400
Received: by wibhr14 with SMTP id hr14so2132100wib.1
        for <linux-wireless@vger.kernel.org>; Sun, 22 Jul 2012 09:51:15 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [RFT][PATCH 0/3] ssb: Flash memory improvements
Date: Sun, 22 Jul 2012 18:51:26 +0200
Message-Id: <1342975889-32687-1-git-send-email-zajec5@gmail.com> (sfid-20120722_185120_219614_54B7014D)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset provides some minor improvements to the flash memory
support. That is based on the OpenWRT tree, recent bcma changes and
some bits from myself.

I don't have any SSB-based embedded device, so it's compile tested only.
And to be honest, I didn't even compile bcm47xx after that changes.

Hauke: I believe you have some SSB SoC, could you give this code a try,
please? I'm doing my best to mainline some random stuff, but I don't
have hardware to test everything.

Rafał Miłecki (3):
  ssb: update defines
  ssb: move flash info to ChipCommon driver
  ssb: check for flash presentence

 arch/mips/bcm47xx/nvram.c                 |    8 +++---
 arch/mips/bcm47xx/wgt634u.c               |   14 ++++++------
 drivers/ssb/driver_mipscore.c             |   34 +++++++++++++++++++++-------
 include/linux/ssb/ssb_driver_chipcommon.h |   15 ++++++++++++-
 include/linux/ssb/ssb_driver_mips.h       |    4 ---
 5 files changed, 50 insertions(+), 25 deletions(-)

-- 
1.7.7

