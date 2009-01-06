Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from exchange07.timesys.com ([209.114.137.35]:40495 "EHLO
	exchange07.timesys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbZAFPmJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 10:42:09 -0500
Message-ID: <49637BD7.5000509@cheek.com> (sfid-20090106_164214_076882_C0B40C2F)
Date: Tue, 6 Jan 2009 10:42:15 -0500
From: Joseph Cheek <joseph@cheek.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] 2.6.27 with compat-wireless-2008-12-31 stops transmitting
 every 2-3 minutes
References: <495C7640.8060806@cheek.com> <20090105170432.GA6834@tesla> <49624B10.70400@cheek.com>
In-Reply-To: <49624B10.70400@cheek.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

looks like i misspoke.  my laptop, this morning, lost its connection for
about 30 seconds while running a remote X app.  I just sshed to another
box (running a g card with a broadcom chipset 8-), exported the display
back to my laptop, and started ripperX.  About 2/3 into the rip the
connection stalled for about 30 seconds and then came back.  perhaps i
didn't see it before because i don't do any video serving from my
laptop?  unsure.  i do watch the videos there, and i would expect the
bandwidth utilization to be the same.  at least it seems bandwidth related.

speaking of the broadcom card, it reassociated with the access point
automatically after a reboot (of the access point).  both d-link/atheros
cards needed some work to get it to reassociate - the desktop needed a
reboot and the laptop needed a reinsertion of the pcmcia card.  possibly
rmmod/modprobe ath9k would have worked to get it to reassociate, but
/etc/init.d/net.wlan0 restart did not work.

thanks for your help!

Joseph Cheek

Joseph Cheek wrote:
> My laptop right next to the AP has no problems staying connected and
> transmitting and receiving with stock 2.6.27.  It's running a DWL-652
> (AR5416).
>   
