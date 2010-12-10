Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46660 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab0LJSsA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Dec 2010 13:48:00 -0500
Subject: Re: b43 N PHY status report
From: Johannes Berg <johannes@sipsolutions.net>
To: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
Cc: Larry Finger <larry.finger@lwfinger.net>,
	=?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
In-Reply-To: <885729A3-72D4-4EFC-AAFE-D2B573E00ED9@ing.unibs.it>
References: <1291755360-21570-1-git-send-email-zajec5@gmail.com>
	 <AANLkTikp9ErFopLZVmXMjN3tXF2L62SwEEcujKeOBLYC@mail.gmail.com>
	 <4CFFA112.7030800@lwfinger.net>
	 <885729A3-72D4-4EFC-AAFE-D2B573E00ED9@ing.unibs.it>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Dec 2010 19:47:54 +0100
Message-ID: <1292006874.3531.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-12-10 at 19:30 +0100, Francesco Gringoli wrote:

> [ 1117.516031] unregister_netdevice: waiting for wlan1 to become free. Usage count = 1
> 
> and the device is never release (by who?). I have to reboot.

That's a bug in the ipv6 code, upgrade your kernel :-)

johannes

