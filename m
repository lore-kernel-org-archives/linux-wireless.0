Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49360 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab1BPUEO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Feb 2011 15:04:14 -0500
Date: Wed, 16 Feb 2011 17:04:08 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: pull request: bluetooth-2.6 2011-02-16
Message-ID: <20110216200407.GI14085@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here goes new fixes to the Bluetooth subsystem for 2.6.38. We have here
support for firmware dowloading for the Atheros AR5BBU12 device. Also a fix
for btusb a crash from Oliver Neukum and a system freeze fix due to not
releasing the Big TTY Mutex in RFCOMM from Vladislav P.

Please pull! :)

The following changes since commit a7b545f7fe753ca3dc1b51ca57f90cd59d974e44:

  mac80211: add missing locking in ieee80211_reconfig (2011-02-09 15:35:13 -0500)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git master

Cho, Yu-Chen (1):
      Bluetooth: Add Atheros BT AR5BBU12 fw supported

Oliver Neukum (1):
      Bluetooth: fix crash with quirky dongles doing sound

Vladislav P (1):
      Bluetooth: Release BTM while sleeping to avoid deadlock

 drivers/bluetooth/ath3k.c  |    3 +++
 drivers/bluetooth/btusb.c  |    7 +++++--
 net/bluetooth/rfcomm/tty.c |    2 ++
 3 files changed, 10 insertions(+), 2 deletions(-)

-- 
Gustavo F. Padovan
http://profusion.mobi
