Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:39094 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbZBUHxL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Feb 2009 02:53:11 -0500
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 0/4] at76c50x-usb: disconnect fixes and dma cleanup
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Sat, 21 Feb 2009 09:53:07 +0200
Message-ID: <20090221075013.15991.66595.stgit@tikku> (sfid-20090221_085315_778461_FA01B3F0)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

here are few fixes from Jason and a comment change from me. Please apply
to the wireless-testing tree.

---

Jason Andryuk (3):
      at76c50x-usb: additional disconnect fixes
      at76c50x-usb: clean up DMA on stack
      at76c50x-usb: fix oops on disconnect

Kalle Valo (1):
      at76c50x-usb: add link to the TODO list


 drivers/net/wireless/at76c50x-usb.c |   80 +++++++++++++++++++++++------------
 1 files changed, 52 insertions(+), 28 deletions(-)

