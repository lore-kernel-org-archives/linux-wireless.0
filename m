Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from n22.bullet.mail.ukl.yahoo.com ([87.248.110.139]:34850 "HELO
	n22.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753619Ab0A0SjY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2010 13:39:24 -0500
Message-ID: <17290.75428.qm@web24706.mail.ird.yahoo.com>
Date: Wed, 27 Jan 2010 18:39:22 +0000 (GMT)
From: John Murdoch <weejoker@yahoo.com>
Subject: Re: wlan/eth bridge stops working after a while: how to diagnose?
To: linux-wireless@vger.kernel.org, hostap@lists.shmoo.com,
	Alexey Yudichev <ayudichev@gmail.com>
In-Reply-To: <4dd58f491001270218t4eaac711xcb42658f8fbf375c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Wed, 27/1/10, Alexey Yudichev <ayudichev@gmail.com> wrote:

> I've got ubuntu 9.10 (hostapd 0.6.9)
> + compat-wireless-2009-12-11 and
> the box is acting as a basic wireless internet router.
> Driver is ath9k
> and server adapter is D-Link DWA-547. All is working fine
> for 2-3 days
> until all of a sudden wireless client (MacBook Pro) stops
> pinging any
> hosts on a local network. The wireless association remains
> and hostapd
> logs are not showing anything unusual. Restarting hostapd
> or even
> networking does not help (although I believe restarting
> networking
> does not work well on ubuntu anyway). Only rebooting the
> server helps.

I've been having the same problems for a long time with two different Mini-PCI cards (AR5416 & AR9160) on Debian 5.0 w/ kernel 2.6.32, with various hostapd and compat-wireless releases (latest combination being hostapd 0.7.1 / compat-wireless 2010-01-26). 

Both cards have similar issues where hostapd permanently stops transmitting beacons from between 10mins to just over 24hrs. There's absolutely nothing in any logs to suggest issues. I can however restart hostapd and the problem is immediately resolved. 
 
> What would you advise to check/debug or otherwise what
> would be the
> best approach to diagnose the problem? I don't see
> anything
> interesting in dmesg, messages or daemon.log at this
> point.

I'm more than willing to collect logs too if pointed in the right direction. 

Regards,

John



      

