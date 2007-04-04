Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cvs.openbsd.org ([199.185.137.3]:36506 "EHLO cvs.openbsd.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566AbXDDVwc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Apr 2007 17:52:32 -0400
Message-Id: <200704042139.l34LdX54017048@cvs.openbsd.org>
To: Michael Buesch <mb@bu3sch.de>
cc: Marcus Glocker <mglocker@openbsd.org>,
	Jon Simola <jsimola@gmail.com>,
	Theo de Raadt <deraadt@theos.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Martin Langer <martin-langer@gmx.de>,
	Danny van Dyk <kugelfang@gentoo.org>,
	Andreas Jaggi <andreas.jaggi@waterwave.ch>,
	Larry Finger <larry.finger@lwfinger.net>, Quaker.Fang@sun.com,
	Johannes Berg <johannes@sipsolutions.net>,
	Joseph Jezak <josejx@gentoo.org>,
	John Linville <linville@tuxdriver.com>,
	Greg kh <greg@kroah.com>, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org,
	license-violation@gpl-violations.org
Subject: Re: OpenBSD bcw: Possible GPL license violation issues 
In-reply-to: Your message of "Wed, 04 Apr 2007 22:08:13 +0200."
             <200704041945.21447.mb@bu3sch.de>
Date: Wed, 04 Apr 2007 15:39:33 -0600
From: Theo de Raadt <deraadt@cvs.openbsd.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> We're not out for blood, just for a fair resolution.
> We'd like you to start contacting us to resolve the issue now.
> 
> Have a nice day.

Wow, that's a hell of a long cc list for a request for a fair
resolution.  the last 3 lines are mellow, but the body before that was
not very nice.

> We have always made and still make a great effort to keep our code clean
> of any Copyright issues (cleanroom design). Please make sure you also do.

We always try to make our stuff as clean as possible too.  In fact, I
think no other code base out there is as clear of violations as ours.
This is a major problem in our code base.

Yes, this driver has other problems though.  To begin with, it does
not even run yet, in any sense.  Since it is not actual using code,
there will be those who argue that the full impact of the GPL does not
come to bear yet -- noone is "using" the code yet.  But beyond that,
these types of problem should not exist in our tree.  It will be
resolved.

But I don't know which way Marcus will do that.  Maybe he'll just
delete the driver and quit even trying, because you chose to cc so
many people, and malign him.  Maybe he'll simply replace every single
line that looks similar, and then he could rightly not even mention
any of the efforts of people like you.  Or he'll could be nicer.
Maybe he will take your rather strong worded mail to a couple hundred
people in a cool way.  I don't know.  It will be choices he has to
make.

It will be resolved in our tree, but it is up to him which way he does
it.  But when you approach issues like this with comments like "We'd
like you to start contacting us to resolve the issue now" and your
first mail is cc'd to a couple hundred people.... in the future,
please think more carefully, ok?

Because right now, in that mail, you've pretty much done Broadcom's
job for them.  You've told the entire BSD community who may want to
use a driver for this chip later, that because of a few GPL issues you
are willing to use very strong words -- published very widely -- to
disrupt the efforts of one guy who is trying to do things for them.
And, you are going to do this using the GPL, even.  You did not
privately mail that developer.  No, you basically went public with it.

That is how about half the user and developer community will see it.
They will see your widely posted mail as an overly strong position.

And you have probably royally pissed of a developer working in
parallel in the same problem space as youself.  Would you be happy to
receive a mail like you just sent?  No, you would be really disturbed,
to your soul.

So next time, talk to the specific people, so you don't come off
as being mean, ok?
