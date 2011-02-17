Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:48013 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745Ab1BQM4R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Feb 2011 07:56:17 -0500
Date: Thu, 17 Feb 2011 13:56:14 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: George <george0505@realtek.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	George <george0505@realtek.com>,
	"John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org, linux-next@vger.kernel.org
Subject: [-next] ERROR: "usb_unanchor_urb" [drivers/net/wireless/rtlwifi/rtlwifi.ko]
 undefined!
Message-ID: <alpine.DEB.2.00.1102171354200.16788@ayla.of.borg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

m68k/allmodconfig:

http://kisskb.ellerman.id.au/kisskb/buildresult/3914133/

ERROR: "usb_unanchor_urb" [drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!
ERROR: "usb_control_msg" [drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!
ERROR: "usb_submit_urb" [drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!
ERROR: "usb_get_dev" [drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!
ERROR: "usb_kill_anchored_urbs" [drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!
ERROR: "usb_put_dev" [drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!
ERROR: "usb_free_urb" [drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!
ERROR: "usb_anchor_urb" [drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!
ERROR: "usb_alloc_urb" [drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!
make[2]: *** [__modpost] Error 1
make[1]: *** [modules] Error 2
make: *** [sub-make] Error 2

The USB-part of rtlwifi should depend on CONFIG_USB.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
