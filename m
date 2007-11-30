Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:50253 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221AbXK3UWk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2007 15:22:40 -0500
Date: Fri, 30 Nov 2007 12:21:15 -0800
To: Shaddy Baddah <shaddy_baddah@hotmail.com>
Cc: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	David Miller <davem@davemloft.net>
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
Message-ID: <20071130202115.GA32444@bougret.hpl.hp.com> (sfid-20071130_202245_793247_CACCF8E8)
Reply-To: jt@hpl.hp.com
References: <4740DF47.4040206@hotmail.com> <20071119.002755.77617097.davem@davemloft.net> <1195484582.8642.18.camel@johannes.berg> <20071119180423.GA19250@bougret.hpl.hp.com> <47443035.1070702@hotmail.com> <20071121184459.GA17199@bougret.hpl.hp.com> <474F86AD.4040403@hotmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <474F86AD.4040403@hotmail.com>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 30, 2007 at 02:42:37PM +1100, Shaddy Baddah wrote:
> Hi,
> 
> First off, sorry for the delay in responding. I am now trying to catch 
> up with my backlog on this issue.

	That's ok, I'm not in a hurry.

> >	The patch from Masakazu Mokuno is not in 2.6.22, and it not
> >either in 2.6.14. The patch is only included in 2.6.23 and later. I
> >would suggest upgrading to 2.6.23 to get that patch. Alternatively,
> >I've included the patch as attachement, and you can use it with
> >2.6.22.
> >	I would like you to try that patch and report.
> 
> Yes, this solved that problem. Thank you,

	Ok, one down, one to go. That's progress.

> >	Note that the patch above *may* help with this issue as well.
> 
> No, it does not seem to have. An iwlist eth2 scanning command still 
> lists a single access point, then fails with a bus error.

	Hmm... That's strange as I was seeing my code behaving as
expected.
	I will ask you to compile a version of wireless tools with
debugging enabled and run it with gdb. See my other e-mail.

> Thanks for your help,
> Shaddy

	No, no. Thanks for your help tracking those issues down. You
have been great.

	Jean

