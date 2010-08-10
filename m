Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:42310 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836Ab0HJB7S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Aug 2010 21:59:18 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Oie7Y-00083w-7d
	for linux-wireless@vger.kernel.org; Tue, 10 Aug 2010 03:59:17 +0200
Received: from 216-31-249-246.static-ip.telepacific.net ([216.31.249.246])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 10 Aug 2010 03:59:16 +0200
Received: from graman by 216-31-249-246.static-ip.telepacific.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 10 Aug 2010 03:59:16 +0200
To: linux-wireless@vger.kernel.org
From: Gopal Raman <graman@arubanetworks.com>
Subject: Re: ath5k : Channel 149 thru 161 not working with =?utf-8?b?CWNvbXBhdC13aXJlbGVzcy0yLjYuMzQuMQ==?=
Date: Tue, 10 Aug 2010 01:59:05 +0000 (UTC)
Message-ID: <loom.20100810T035826-791@post.gmane.org>
References: <loom.20100805T020816-848@post.gmane.org> <loom.20100805T025322-892@post.gmane.org> <AANLkTikcWNzO7tbheeJp=NYMsY=Kh983DrR2P=OKCJ5p@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jonathan Guerin <jonathan@...> writes:

> 
> I found issues when switching to ath5k where the wrong antenna was selected.
> 
> Try forcing the antenna (especially if you don't have 1 of them
> plugged in) and see how you go:
> http://www.mail-archive.com/ath5k-devel-xDcbHBWguxEUs3QNXV6qNA <at>
public.gmane.org/msg02979.html
> 
> Cheers,
> 
> --
> Jonathan Guerin


Hi
I downloaded the latest compat-wireless snapshot and this time found the debug
node in the debugfs filesystem for the ath5k antenna. I set it to the 4 values
possible i.e "diversity", "fixed-a", "fixed-b" and "clear" but still can't
receive anything on channel 149.

Can someone confirm that they can see frames in channels 149 thru 161 ? If the
driver works on these channels, it must be something to do with my h/w

Thanks

-gopal


