Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:58483 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759886AbZKZJCP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 04:02:15 -0500
Subject: [PATCH 0/3] wl1251 power save fixes for 2.6.33
To: linville@tuxdriver.com
From: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 26 Nov 2009 10:55:48 +0200
Message-ID: <20091126085256.1564.77644.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

my testing revealed serious power save problems in wl1251. If possible,
please send the fixes to 2.6.33. The patches should be simple enough and
they make a huge improvement.

---

Kalle Valo (3):
      wl1251: remove false warning messages
      wl1251: fix bssid handling
      wl1251: don't build null data template in wl1251_op_config()


 drivers/net/wireless/wl12xx/wl1251_main.c |   36 ++++++++++++-----------------
 1 files changed, 15 insertions(+), 21 deletions(-)

