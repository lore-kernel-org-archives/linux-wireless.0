Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:43398 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754394Ab1CUUmZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 16:42:25 -0400
Date: Mon, 21 Mar 2011 13:42:23 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arend van Spriel <arend@broadcom.com>, george@znau.edu.ua,
	zajec5@gmail.com, mb@bu3sch.de, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] drivers: brcmaxi: provide amba axi functionality in
 separate module
Message-Id: <20110321134223.43791d78.rdunlap@xenotime.net>
In-Reply-To: <1300739892.13397.4.camel@jlt3.sipsolutions.net>
References: <1300738586-7157-1-git-send-email-arend@broadcom.com>
	<1300738586-7157-2-git-send-email-arend@broadcom.com>
	<20110321132848.e4e846a5.rdunlap@xenotime.net>
	<1300739892.13397.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 21 Mar 2011 21:38:12 +0100 Johannes Berg wrote:

> On Mon, 2011-03-21 at 13:28 -0700, Randy Dunlap wrote:
> 
> > > +/**
> > > + * DOC: Core Utility Functions
> 
> > This is not kernel-doc notation.  Change /** to /*.
> 
> Actually, it is, if you prefix with DOC: you can embed that into the
> generated DocBook with 
> !P<file> <heading name>
> and include the text. I did that in b112e0f7 :-)

Yes, I'm familiar with that notation.


bah.  You omitted a few lines of comments:

> +/**

This is not kernel-doc notation.  Change /** to /*.

> + * Manufacturer Ids
> + */



> > > +/**
> > 
> > ditto
> > 
> > > + * Component Classes
> 
> You're right for most of the other ones of course.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
