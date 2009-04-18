Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:60298 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbZDROfX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Apr 2009 10:35:23 -0400
Date: Sat, 18 Apr 2009 10:34:16 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
To: Johannes Berg <johannes@sipsolutions.net>
cc: linux-wireless@vger.kernel.org
Subject: Re: bad reference to atheros ar71xx config variable?
In-Reply-To: <1240065163.20540.3.camel@johannes.local>
Message-ID: <alpine.LFD.2.00.0904181032180.25930@localhost.localdomain> (sfid-20090418_163526_468227_61D2C461)
References: <alpine.LFD.2.00.0904181020490.25540@localhost.localdomain>  (sfid-20090418_162436_362181_72D1EA2C) <1240065163.20540.3.camel@johannes.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 18 Apr 2009, Johannes Berg wrote:

> On Sat, 2009-04-18 at 10:23 -0400, Robert P. J. Day wrote:
> > ./drivers/net/wireless/ath9k/Makefile:ath9k-$(CONFIG_ATHEROS_AR71XX) += ahb.o
> >
> >   there appears to be no such config variable.  is that a typo?
>
> That's some embedded system iirc, maybe the arch code hasn't gone in
> yet?

  entirely possible, i'm simply pointing out the existence of such
things.  sometimes it's because the code hasn't gone in yet, sometimes
it's an actual typo.  i'll leave it with you folks to resolve or
ignore. :-)

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
