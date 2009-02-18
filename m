Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:56180 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbZBRUkx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 15:40:53 -0500
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 0/2] at76c50x-usb fixes for latest mac80211
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Wed, 18 Feb 2009 22:40:49 +0200
Message-ID: <20090218203830.19847.88862.stgit@tikku> (sfid-20090218_214058_500915_E48D6A14)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

here are Jason's fixes for at76c50x-usb. They apply on top of patch I sent
to the list few weeks ago.

I have tested this myself and the driver seems to work fine for me.

---

Jason Andryuk (2):
      at76c50x-usb: convert at76_debug to an unsigned int
      at76c50x-usb: update to latest mac80211 hw scan api


 drivers/net/wireless/at76c50x-usb.c |   28 ++++++++++++++++++++--------
 1 files changed, 20 insertions(+), 8 deletions(-)

