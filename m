Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:60460
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767328AbXDEV1R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Apr 2007 17:27:17 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Theo de Raadt <deraadt@cvs.openbsd.org>
Subject: Re: OpenBSD bcw: Possible GPL license violation issues
Date: Thu, 5 Apr 2007 23:26:22 +0200
Cc: Jeff Garzik <jeff@garzik.org>,
	Marcus Glocker <mglocker@openbsd.org>,
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
References: <200704052056.l35KuTIr025210@cvs.openbsd.org>
In-Reply-To: <200704052056.l35KuTIr025210@cvs.openbsd.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200704052326.23288.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 05 April 2007 22:56, Theo de Raadt wrote:
> It makes me happy to show that I have empathy for a situation where
> someone who puts hundreds of hours of work in as a hobby, and to
> defend that person.  It makes me extremely unhappy that I have to do
> so, and that some other people think this is a non-event.

We put THOUSANDS of hours of work into bcm43xx and you
simply relicense it without permission. Your point being?

> > > <rest deleted, because the above line is so important>
> > 
> > Snipped?  I presume, then, you admit you are misrepresenting others' 
> > opinions in this thread.
> 
> No, there was a side discussion about whitespace and variable naming,
> and even algorithms covered by the GPL.  Gimme a break.  These were
> essentially claimed by some of the examples shown by Michael.  Go look
> carefully.

You simply don't get it. These were EXAMPLES of why we think the
code was copied 1:1. This has NOTHING to do with copyright law
at this point. It simply shows: "Oh look, you named that variable
or that function exactly like I did, although the specs did not
suggest naming. Unlikely to be so by coincidence."

> That said, there were more real issues, and those have been dealt with
> in a reply from Marcus, plus the driver now being deleted.

I want to point out again that I _never_ made it a requirement
to delete the driver. I offered ways to handle it by going through
the code and judging on a case-by-case base of what can stay and
what has to be rewritten by you.

> The Italian dude in particular was complaining bitterly in private
> mail about the whitespace similarities... good grief, not whitespace
> similarities.  How SCO of him.

Yeah. Must be coincidence that you typed whitespace exactly like
we did. I'm sure this didn't come from copying, but from coincidence.

[Irony may be found in the mail above]

-- 
Greetings Michael.
