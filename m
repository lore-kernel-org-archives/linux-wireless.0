Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:40230 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098AbYCCLUF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2008 06:20:05 -0500
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1JW8iA-0008FT-5V
	for linux-wireless@vger.kernel.org; Mon, 03 Mar 2008 11:20:02 +0000
Received: from dsl081-096-236.den1.dsl.speakeasy.net ([64.81.96.236])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 03 Mar 2008 11:20:02 +0000
Received: from gmane by dsl081-096-236.den1.dsl.speakeasy.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 03 Mar 2008 11:20:02 +0000
To: linux-wireless@vger.kernel.org
From: Joe Wise <gmane@joewise.com>
Subject: Re: can't bring up wlan0
Date: Mon, 3 Mar 2008 11:15:02 +0000 (UTC)
Message-ID: <loom.20080303T110557-828@post.gmane.org> (sfid-20080303_112016_364851_4CBF48D9)
References: <20080223153142.da9fc4e4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrew Morton <akpm@...> writes:

> 
> 
> I've been noticing this for a week or two but hadn't paid it much attention
> amongst the storm of other bugs.
> 
> This is on the t61p laptop, running FC8.
snip
> 
> 
> t61p:/home/akpm# ifconfig wlan0 up
> SIOCSIFFLAGS: No such device
> 
> 
> Any ideas?  Could be that it's some new Kconfig which was added post-2.6.24
> and which defaults to broken-mode when one runs `make oldconfig'.  Which is
> a rather unpleasing practice which happens quite a lot.
> 
> Thanks.
> 
> # Automatically generated make config: don't edit
snip
> CONFIG_HAS_IOPORT=y



I have this identical problem, however I'm running kernel 2.6.23.15-137.fc8. 
Although it's probably not noteworthy, I'm actually on a lenovo t61, not a t61p.

Hope this helps somebody fix the problem.

-Joe



