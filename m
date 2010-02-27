Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:57978 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966330Ab0B0MDn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Feb 2010 07:03:43 -0500
Received: by fxm19 with SMTP id 19so915402fxm.21
        for <linux-wireless@vger.kernel.org>; Sat, 27 Feb 2010 04:03:42 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 00/10] b43: more N-PHY patches, try #2
Date: Sat, 27 Feb 2010 13:03:31 +0100
Message-Id: <1267272221-1873-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John: there is one patch less in comparision to first patchset, previous try
was some time ago, so fianlly I decided to resend all patches. I guess half
of them did not really changed. Are you fine with this?

Rafał Miłecki (10):
  b43: N-PHY: add some registers and structs definitions
  b43: N-PHY: initialize super switch
  b43: N-PHY: turn radio on/off (rfkill)
  b43: N-PHY: update writing channel-specific radio registers
  b43: N-PHY: update post init of 2055 radio
  b43: N-PHY: switch to chanspec struct
  b43: N-PHY: adjust gain table
  b43: N-PHY: isloate 2055 radio setup
  b43: N-PHY: implement chanspec setup
  b43: N-PHY: switch to chanspec ops

 drivers/net/wireless/b43/b43.h         |    1 +
 drivers/net/wireless/b43/phy_n.c       |  463 +++++++++++++++++++++++++-------
 drivers/net/wireless/b43/phy_n.h       |   21 ++-
 drivers/net/wireless/b43/tables_nphy.h |    9 +
 4 files changed, 387 insertions(+), 107 deletions(-)

