Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:47601 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752437Ab1LUUgk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 15:36:40 -0500
Received: by mail-lpp01m010-f42.google.com with SMTP id j5so3149925lag.15
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2011 12:36:38 -0800 (PST)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com
Subject: [PATCH 0/3] wl1251: sparse warning and endianess fixes
Date: Wed, 21 Dec 2011 22:36:26 +0200
Message-Id: <1324499789-13525-1-git-send-email-coelho@ti.com> (sfid-20111221_213643_408696_2855CFC1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

It's been a long time since wl1251 got any updates.  Following the
wave of endianess sparse checks enablement, I decided to do the same
for wl1251.

While at it, I found one sparse warning and a couple of endianess
bugs.  This patchset fixes them.

Cheers,
Luca.

PS: John, I'll take this through my tree, as we had agreed.  Just a
reminder. ;)

Luciano Coelho (3):
  wl1251: fix sparse warning
  wl1251: convert 32-bit values to le32 before writing to the chip
  wl1251: enable sparse endianess check by default

 drivers/net/wireless/wl1251/Makefile |    2 ++
 drivers/net/wireless/wl1251/boot.c   |    2 --
 drivers/net/wireless/wl1251/io.h     |    9 ++++-----
 drivers/net/wireless/wl1251/wl1251.h |    2 +-
 4 files changed, 7 insertions(+), 8 deletions(-)

-- 
1.7.4.1

