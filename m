Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41565 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379Ab1CUUpx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 16:45:53 -0400
Subject: Re: [RFC] drivers: brcmaxi: provide amba axi functionality in
 separate module
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Arend van Spriel <arend@broadcom.com>, george@znau.edu.ua,
	zajec5@gmail.com, mb@bu3sch.de, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <20110321134223.43791d78.rdunlap@xenotime.net>
References: <1300738586-7157-1-git-send-email-arend@broadcom.com>
	 <1300738586-7157-2-git-send-email-arend@broadcom.com>
	 <20110321132848.e4e846a5.rdunlap@xenotime.net>
	 <1300739892.13397.4.camel@jlt3.sipsolutions.net>
	 <20110321134223.43791d78.rdunlap@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Mar 2011 21:45:44 +0100
Message-ID: <1300740344.13397.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-03-21 at 13:42 -0700, Randy Dunlap wrote:
> On Mon, 21 Mar 2011 21:38:12 +0100 Johannes Berg wrote:
> 
> > On Mon, 2011-03-21 at 13:28 -0700, Randy Dunlap wrote:
> > 
> > > > +/**
> > > > + * DOC: Core Utility Functions
> > 
> > > This is not kernel-doc notation.  Change /** to /*.
> > 
> > Actually, it is, if you prefix with DOC: you can embed that into the
> > generated DocBook with 
> > !P<file> <heading name>
> > and include the text. I did that in b112e0f7 :-)
> 
> Yes, I'm familiar with that notation.
> 
> 
> bah.  You omitted a few lines of comments:
> 
> > +/**
> 
> This is not kernel-doc notation.  Change /** to /*.

Oops, I just looked at the original again and noticed that in fact you
were commenting on a new block that started. You're right, of course,
sorry!

johannes

