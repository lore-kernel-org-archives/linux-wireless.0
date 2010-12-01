Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41582 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755449Ab0LAVLM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 16:11:12 -0500
Date: Wed, 1 Dec 2010 19:11:28 -0200
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: linville@tuxdriver.com
Cc: marcel@holtmann.org, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org
Subject: pull request: bluetooth-2.6 2010-11-01
Message-ID: <20101201211128.GC16125@vigoh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here goes 3 simple patches intended to 2.6.37. First one is from myself
and fix some trivial return values. Then we also have a fix from Stefan
Seyfried on btusb to avoid emitting an err when we USB is autosupended.
Last, a patch from Bala Shanmugam that fix the firmware loading process
for the ath3k driver.

Please pull, or let me know if you disagree with the patches. Thanks a
lot. ;)


The following changes since commit 916448e77f6bcaaa7f13c3de0c3851783ae2bfd0:

  ath9k: Fix STA disconnect issue due to received MIC failed bcast frames (2010-11-30 13:45:02 -0500)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git master

Bala Shanmugam (1):
      Bluetooth: Add new PID for Atheros 3011

Gustavo F. Padovan (1):
      Bluetooth: Fix not returning proper error in SCO

Stefan Seyfried (1):
      Bluetooth: Fix log spamming in btusb due to autosuspend

 drivers/bluetooth/ath3k.c |    4 ++++
 drivers/bluetooth/btusb.c |   12 +++++++++---
 net/bluetooth/sco.c       |    6 +++---
 3 files changed, 16 insertions(+), 6 deletions(-)

-- 
Gustavo F. Padovan
http://profusion.mobi
