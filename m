Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:7216 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024Ab0CZUs6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Mar 2010 16:48:58 -0400
Subject: Re: Memory leaks from swapper, wpa_supplicant, glxgears
From: Pavel Roskin <proski@gnu.org>
To: "Daniele C." <legolas558@users.sourceforge.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4BACBD71.9040107@users.sourceforge.net>
References: <4BACBD71.9040107@users.sourceforge.net>
Content-Type: text/plain
Date: Fri, 26 Mar 2010 16:48:57 -0400
Message-Id: <1269636537.8534.11.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-03-26 at 14:58 +0100, Daniele C. wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Hello there,
> 
> I have enabled CONFIG_KMEMLEAK and I am finding some memory leakage
> apparently caused by "swapper" process; I have also had leaks from
> glxgears and wpa_supplicant, but they can be triggered only once (e.g.
> restarting wpa_supplicant does not trigger more leaks).
> 
> The swapper leaks seem to be an incremental decimal string, starting
> from "0" to "10", while the wpa_supplicant leaks were the AP ESSID
> (not in attached report).

The attachment is quite useless since it has no function names, only
numeric addresses that vary between systems.

The backtrace that only has 0xffffffff suggests that kmemleak is not
working properly on your system.

Please figure out how to use kmemleak first.

-- 
Regards,
Pavel Roskin
