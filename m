Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34679 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757326Ab0KRT6B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 14:58:01 -0500
Received: by bwz15 with SMTP id 15so3136659bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 18 Nov 2010 11:57:59 -0800 (PST)
Message-ID: <4CE5853E.5040009@lwfinger.net>
Date: Thu, 18 Nov 2010 13:57:50 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: kiltym@hotmail.com
CC: "'John W. Linville'" <linville@tuxdriver.com>,
	htl10@users.sourceforge.net,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: RTL8187L Linux Help-Information
References: <BLU0-SMTP1176E6E431CFB5440B181AEC1370@phx.gbl> <20101116142437.GB10774@tuxdriver.com> <COL113-DS10D0DD87CD6532D6FBF4B6C1390@phx.gbl>
In-Reply-To: <COL113-DS10D0DD87CD6532D6FBF4B6C1390@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/18/2010 12:42 PM, Mark Kilty wrote:
> Hi,
> 
> I just noticed I did not Reply To All to John's email.  Here is the content

I wondered what happened to your response.

> Hi John,
> 
> Thanks for getting back to me.  Its appreciated.
> 
> To answer your questions:
> 
> We have 2 issues with the driver we are using (it's the current driver from
> Realtek, v1040). 
> 	1) It loses connectivity after a "random" period of time.  As in,
> the unit will work fine for a while, and then, maybe after 20 minutes, 2
> hours, 8 hours, etc, it will stay connected to the AP, but the throughput is
> brought to almost 0.  When doing a simple ping to the access point,
> sometimes it will go through, but most of the time it will timeout.  We have
> not been able to find a "pattern" as of yet as to when/why it drops.
> 	2) The overall performance of the chip under windows is better than
> under Linux (more below).  Realtek has stated something to be about not
> supporting "high power" on linux, but am not 100% sure what that means as I
> would have assumed this is a hardware thing, not a software thing.
> 
> Our product is a long range WiFi system.  We are working on a new product,
> that integrates with the RTL8187L as this chip has proven to be the best
> long-range Wifi card for b/g networks.  There are other chips/WiFi adapters
> on the market, but under Windows/Mac, this chip outperforms all of them.
> For us, the distance we can connect is the most important factor.
> Speed/throughput is secondary.
> 
> I am certainly able to provide additional information with more specifics if
> you are interested and we sign an NDA.
> 
> We have been in contact with Realtek, but they have not been very responsive
> (surprising for a company like this that is stating they support Linux, but
> are doing so in a half-ass way (excuse my French :) )).  So, I am very
> actively trying to locate someone with driver experience that can work from
> the Realtek drivers and diagnose and resolve the current issues we have, and
> potentially any others in the future.
> 
> Is this something you might be interested in?

After a set of recent changes to rtl8187 that increased the throughput of the
RTL8187B by about a factor of 2.5, I implemented the latest Realtek driver to
see if it had any improvement over rtl8187 for the RTL8187L chip. It did not -
in fact the performance went down. In exactly the same station/AP arrangement,
the TX speed of rtl8187 was at least 1.5 times that of the vendor driver (1040).
I also found it not to be able to maintain a stable connection, whereas rtl8187 can.

Is there some reason for you to choose the vendor driver over rtl8187? If it is
the kernel version, I should be able to help you with that.

I am a little busy at the moment with drivers for some other Realtek devices. I
am developing a good working relationship with their in-house developers, and
working on mainline drivers for several 802.11n devices, but I might consider
some extra work. If no one else has responded, please contact me off-list.

Larry


