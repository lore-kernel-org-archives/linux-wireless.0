Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:31575 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbZG0S40 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 14:56:26 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2009 11:56:27 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/2] ar76c50x-usb: few mac80211 workqueue usage fixes
Date: Mon, 27 Jul 2009 11:56:22 -0700
Message-ID: <1248720984-15922-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Part of the mac80211 workqueue review.

Luis R. Rodriguez (2):
  ar76c50x-usb: cancel promisc work during mac80211 stop
  at76c50x-usb: cancel scan work at stop callback

 drivers/net/wireless/at76c50x-usb.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

