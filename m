Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:55031 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbXLEXlS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2007 18:41:18 -0500
Date: Wed, 5 Dec 2007 15:40:59 -0800
To: Shaddy Baddah <shaddy_baddah@hotmail.com>
Cc: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	David Miller <davem@davemloft.net>
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
Message-ID: <20071205234059.GB29299@bougret.hpl.hp.com> (sfid-20071205_234123_181341_7E1B7882)
Reply-To: jt@hpl.hp.com
References: <1195484582.8642.18.camel@johannes.berg> <20071119180423.GA19250@bougret.hpl.hp.com> <47443035.1070702@hotmail.com> <20071121184459.GA17199@bougret.hpl.hp.com> <474F86AD.4040403@hotmail.com> <20071130202115.GA32444@bougret.hpl.hp.com> <20071204000138.GA1363@bougret.hpl.hp.com> <4756AABC.3000204@hotmail.com> <20071205215600.GA28349@bougret.hpl.hp.com> <4757336F.7050301@hotmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4757336F.7050301@hotmail.com>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 06, 2007 at 10:25:35AM +1100, Shaddy Baddah wrote:
> Hi Jean,
> 
> Linux trad 2.6.22 #2 Fri Nov 30 13:47:43 EST 2007 sparc64 GNU/Linux
> 
> (just noticed that the clock is wrong. I'll sort that out later).

	ntpdate + ntpd is your friend. I believe the CMOS battery is
dead on my oldest computers.

> >	In any case, I've modified my code to use a memcpy() instead
> >of direct memory access. I'm not 100% sure it will fix it because many
> >time memcpy() is optimised away to a direct memory access.
> >
> >	So, you'll find attached a new version of Wireless Tools. Just
> >tell me if it work. You can remove the debugging output by commenting
> >out the "#define DEBUG" lines (grep for it).
> 
> Yes, that has fixed it. Thank you very much.

	Wow ! You means it's all working good now ? You don't see any
more problems ?
	I also believe that this was the last issue you had with
Wireless Tools/Wireless Extensions. I believe the driver issue is in
good hands.
	If that's the case, I'll release soon a new Wireless Tools
version and push that to distros.

> Regards,
> Shaddy

	Thanks a lot !

	Jean
