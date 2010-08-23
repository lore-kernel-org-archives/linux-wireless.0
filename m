Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:56737 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751762Ab0HWJgT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 05:36:19 -0400
Content-Type: text/plain; charset="utf-8"
Date: Mon, 23 Aug 2010 11:36:15 +0200
From: garkein@mailueberfall.de
Message-ID: <20100823093615.36500@gmx.net>
MIME-Version: 1.0
Subject: 11h frequency change support in iwlwifi?
To: linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I would like to know whether the client side support for 11h frequency change on radar detection is supported in the iwlwifi driver (and/or mac80211 if relevant).

I've learned that there is some kind of protocol with which the AP tells all clients about a radar related frequency change, which allow the clients to seamlessly follow the AP to the new channel.

Apparently this is either not supported or working in Linux/iwlwifi as my 5100agn repeatedly just looses the AP if that changes the channel due to radar instead of seamlessly following it. (which is bad, no fun if the client looses internet ;-))

That why I'm asking whether this currently supported in iwlwifi/Linux and if so, what debug flags I should switch on to gain some more information on what might be going wrong.


Regards,
Daniel

-- 
GMX DSL SOMMER-SPECIAL: Surf & Phone Flat 16.000 für nur 19,99 ¿/mtl.!*
http://portal.gmx.net/de/go/dsl
