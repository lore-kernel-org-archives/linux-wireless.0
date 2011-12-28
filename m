Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:3192 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752627Ab1L1A7x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Dec 2011 19:59:53 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: John W Linville <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 0/7] Assorted fixes and clean-ups.
Date: Wed, 28 Dec 2011 01:53:17 +0100
Message-Id: <1325033604-26469-1-git-send-email-gwingerde@gmail.com> (sfid-20111228_020008_463709_7EC6F331)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Assorted fixes and clean-ups for rt2x00.

Note these patches are on top of Larry Finger's uncommitted patch in
http://marc.info/?l=linux-wireless&m=132501461624898&w=2

Gertjan van Wingerde (6):
  rt2x00: Identify rt2800usb chipsets.
  rt2x00: Whitespace cleanup.
  rt2x00: Convert big if-statements to switch-statements.
  rt2x00: RT3593 is also applicable to USB.
  rt2x00: Change RF3853 to RF3053.

Jakub Kiciński (2):
  rt2800usb: Let rt2x00usb handle USB padding
  rt2x00usb: Zero USB padding before sending URB

 drivers/net/wireless/rt2x00/rt2800.h    |    4 +-
 drivers/net/wireless/rt2x00/rt2800lib.c |   55 ++++++++++++++++----------
 drivers/net/wireless/rt2x00/rt2800usb.c |   65 +++++++++++--------------------
 drivers/net/wireless/rt2x00/rt2x00.h    |    4 +-
 drivers/net/wireless/rt2x00/rt2x00usb.c |   16 ++++++-
 5 files changed, 74 insertions(+), 70 deletions(-)

-- 
1.7.7.4

