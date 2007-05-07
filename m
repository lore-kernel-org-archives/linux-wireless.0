Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.226]:11492 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367AbXEGOpw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2007 10:45:52 -0400
Received: by wx-out-0506.google.com with SMTP id h31so1420705wxd
        for <linux-wireless@vger.kernel.org>; Mon, 07 May 2007 07:45:50 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Please pull 'upstream' branch of rt2x00
Date: Mon, 7 May 2007 16:44:04 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200705071644.04150.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here is the latest rt2x00 update. It is a rather small one.
Only 1 real fix, and the second path is cosmetic since it
will start a proper versioning of rt2x00.

This will most likely be the last pull request for the next 1 or 2 months
due to developer/time/health shortage.

The TODO list for rt2x00 has been expanding over the last few days,
so as soon as I am fully back there will be quite a lot to do. ;)
(http://rt2x00.serialmonkey.com/wiki/index.php?title=Rt2x00_beta#rt2x00_beta_status_page)

Ivo

---

The following changes since commit 5209b1eff0b1891d8bb002eb067a11b4caa5f5bc:
  John W. Linville (1):
        Merge branch 'from-linus'

are found in the git repository at:

  http://git.serialmonkey.com/rt2x00.git/ upstream

Ivo van Doorn (2):
      rt2x00: release 2.0.0
      Merge branch 'wireless-dev'

Jan Kiszka (1):
      rt2x00: Fix master beacon setup

 drivers/net/wireless/mac80211/rt2x00/rt2400pci.c |    8 +++-----
 drivers/net/wireless/mac80211/rt2x00/rt2500pci.c |    8 +++-----
 drivers/net/wireless/mac80211/rt2x00/rt2500usb.c |    8 +++-----
 drivers/net/wireless/mac80211/rt2x00/rt2x00.h    |    3 +--
 drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c |   17 -----------------
 drivers/net/wireless/mac80211/rt2x00/rt2x00mac.c |   14 +++++++++++++-
 drivers/net/wireless/mac80211/rt2x00/rt2x00pci.c |   17 -----------------
 drivers/net/wireless/mac80211/rt2x00/rt2x00usb.c |   19 +------------------
 drivers/net/wireless/mac80211/rt2x00/rt61pci.c   |    8 +++-----
 drivers/net/wireless/mac80211/rt2x00/rt73usb.c   |    8 +++-----
 10 files changed, 30 insertions(+), 80 deletions(-)
