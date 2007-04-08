Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [83.246.81.11] ([83.246.81.11]:23423 "EHLO slim.vantronix.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbXDHNgA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Apr 2007 09:36:00 -0400
Date: Sun, 8 Apr 2007 15:27:43 +0200
From: Reyk Floeter <reyk@openbsd.org>
To: proski@gnu.org, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Cc: Marcus Glocker <mglocker@openbsd.org>,
	Theo de Raadt <deraadt@theos.com>,
	Reyk Floeter <reyk@openbsd.org>
Subject: Re: OpenBSD bcw: Possible GPL license violation issues
Message-ID: <20070408132743.GA12836@slim.vantronix.net>
References: <200704041945.21447.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200704041945.21447.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm not subscribed to this list but I followed the discussion in the
public archives. My name and my work on the free Atheros driver (ar5k,
also known as "OpenHAL") has been mentioned in this thread and I'd
like to comment some things.

On 2007-04-05 19:31:27 GMT, Pavel Roskin wrote:
> I'm a member of linux-wireless list, an occasional contributor to
> bcm43xx and a MadWifi developer.
>
> It has been a few months ago that I was feeling bad for another OpenBSD
> driver developer.  The MadWifi team asked him to relicense parts of the
> driver (so called openhal) under GPL so that if would be easier for us
> to erase the boundary between the HAL and the rest of MadWifi and
> eventually integrate it into the Linux kernel.
>
> We got a message from you, which was rather abusive, and it just made
> impossible for that OpenBSD developer to do anything but to deny our
> request.  I was feeling bad for him, because it was his code.  I would
> not want to be in a similar situation.
>
> Now you are asking us to be sensitive towards somebody who just took the
> code under GPL and put it under BSD license without asking any
> questions, nicely or otherwise.
> 
> I'm sorry, but your Harlequin show is woefully unconvincing and
> out-of-date.  Knowing something about you, I think a "sensitive OpenBSD
> developer" is an oxymoron.
>

I'm sure that somebody forwarded the mails from our private
discussions to you where I clearly denied the requests to change the
license of my driver. I do not believe in dual licensing, and it would
make my driver less free. It does not add a benefit for us but it does
introduce additional problems. I don't want to take care of GPL
licensing issues, and I do not want to distinguish between BSD/ISC
code on the one hand and GPL code on the other hand.

Let me repeat the very simple license terms again:

 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.

I clearly expressed in a mail from 2006/08/24 that I do support the
idea of having a BLOB-free driver in your OS. I said that "you can
use, modify, distribute, print, paint, sing, ... my code but please
keep the copyright notice and the license.". I also like to thank Nick
Kossifidis because he was the _only_ developer working on a Linux port
who stopped talking about licensing blah and send me some code,
feedback, and bug reports.

But you make an idiot out of me.

You either totally misinterpreted my statements or you just want to
spread the FUD that every OpenBSD developer is mind-controlled by
Theo. I involved Theo _after_ I denied the various requests to change
the license of my driver because the various people didn't stop to
repeat their requests. You involved lawyers to question my code.

Instead of attacking developers of non-GPL free software, you should
point your lawyers into another direction to think about ways to
include GPL-compatible BSD/ISC code in the Linux kernel without the
need for relicensing it. Talk to the Linux maintainers to change this
stupid Dual GPL/* policy.

It is your choice, you can also rewrite the "OpenHAL" and take my code
as a reference. The copyright does not protect the "idea" of the
implementation or the algorithms. Feel free to read my code, interpret
it and express it differently.

>From my point of view GPL software is non-free because I cannot simply
reuse it in my code. It may work within the Linux world, but everybody
else is restricted from using it. This is especially a problem when we
depend on the Linux drivers as the only reference to write drivers for
OpenBSD.

--//--

On Wed, Apr 04, 2007 at 10:08:13PM +0200, Michael Buesch wrote:
> [citing Michael, Date unknown]
> "What if Broadcom decides to take our LO measure state machine and
> put it into the original driver? (The Rev Engineers told me they have
> a very different weird solution for this in their code).
> I really don't want to see this happen."
> 

So what? Nobody prevents Broadcom to implement a LO measure state
machine based on your idea. And it is totally legal.

It appears to me that you intend to sign an agreement with Broadcom to
sell them a dual GPL/non-free license to use your Linux driver without
restrictions. Isn't it the main purpose of the dual GPL/* licensing
strategy? Why should you care otherwise that they can just use your
code?

Reyk
