Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:64535 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752016Ab0CXUmv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Mar 2010 16:42:51 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 0/2] Two small fixes for rt2x00.
Date: Wed, 24 Mar 2010 21:42:35 +0100
Message-Id: <1269463357-32563-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

These are two small fixes for rt2x00 that accumulated in my tree.
Both are generated against wireless-2.6, but should apply to
wireless-next-2.6, so apply to the tree you feel most appropriate
for this.

The patches can also be pulled from:

	git://git.gwingerde.nl/rt2x00-2.6

Gertjan van Wingerde (2):
  rt2x00: Fix typo in RF register programming of rt2800.
  rt2x00: Disable powersaving by default in rt2500usb.

 drivers/net/wireless/rt2x00/rt2500usb.c |    5 +++++
 drivers/net/wireless/rt2x00/rt2800lib.c |    4 ++--
 2 files changed, 7 insertions(+), 2 deletions(-)

