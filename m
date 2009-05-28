Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42708 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbZE1VgF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2009 17:36:05 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, chunkeey@web.de
Cc: linux-wireless@vger.kernel.org, jal2@gmx.de,
	Peter.Grabienski@Atheros.com, Stephen.Chen@Atheros.com,
	Michael.Fortin@Atheros.com, Johnny.Cheng@Atheros.com,
	Yuan-Gu.Wei@atheros.com, otus-devel@lists.madwifi-project.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/2] ar9170: 1-stage firmware support / AVM fritz
Date: Thu, 28 May 2009 17:36:03 -0400
Message-Id: <1243546565-19404-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series now works for me on my WNDA31000, it took a newer shiny
1-stage firmware to work. I'll push the firmware into linux-firmware
next.

Should work with the AVM Fritz devices now, haven't tested it but
I think it should work.

Luis R. Rodriguez (2):
  ar9170: add support for 1-stage firmware
  ar9170: add AVM FRITZ devices

 drivers/net/wireless/ath/ar9170/usb.c |   47 +++++++++++++++++++++++++++++---
 drivers/net/wireless/ath/ar9170/usb.h |    2 +
 2 files changed, 44 insertions(+), 5 deletions(-)

