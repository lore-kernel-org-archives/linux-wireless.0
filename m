Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from msr8.hinet.net ([168.95.4.108]:62383 "EHLO msr8.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752997Ab1GPKxN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jul 2011 06:53:13 -0400
Date: Sat, 16 Jul 2011 18:50:19 +0800
From: Ali Bahar <ali@internetdog.org>
To: Kalle Valo <kvalo@adurom.com>
Cc: ali@internetdog.org, Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: r8712u: Most return-values changed from
 -1 to proper errno macros.
Message-ID: <20110716105019.GA2176@internetdog.org> (sfid-20110716_125323_289954_AC3FD48E)
Reply-To: ali@internetdog.org
References: <20110703010605.GA3736@internetdog.org>
 <1310749876-32632-1-git-send-email-ali@internetDog.org>
 <1310749876-32632-2-git-send-email-ali@internetDog.org>
 <4E20AA5A.6020101@lwfinger.net>
 <20110716032100.GA3274@internetdog.org>
 <87zkkevash.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87zkkevash.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,


On Sat, Jul 16, 2011 at 12:23:42PM +0300, Kalle Valo wrote:
> Ali Bahar <ali@internetdog.org> writes:
> 
> > I am aware of the current state of the Linux code's documentation.
> > Habitually, I comment the big-picture as I go along. Industry
> > practice wrt comments differs from Linux's, of course. The comments
> > were in the function heads, not in the bodies, as per
> > Documentation/CodingStyle. The big-picture of the functions is clear
> > once you are familiar enough to begin to modify the code. However,
> > and especially for linux, code is read a thousand times for every
> > time it is written. Most eyeballs could do with a line or two of
> > explanation. To me, Documentation/kernel-docs.txt echoed the need
> > for a big-picture view. 
> 
> The problem with comments is that they quickly get out of date

Oh boy! I did say I don't want to start a debate, but only to explain
my original intentions. Never the less, I thank you for your response.
It suffices to say that we are mostly in agreement. Key is that my
statements were _not_ about in-body documentation.




> the actual code. So there needs to be a trade-off and in Linux it has
> been that code should be of good quality so that it's easy to read for
> everyone but there will be less comments.

My stance is that, if I were to ever argue otherwise, I should first
dig thru lkml archives for past discussions -- which is only one of
the reason why I don't debate this. :-)


> Kalle Valo

thanks,
ali
