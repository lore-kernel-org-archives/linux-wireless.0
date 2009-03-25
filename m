Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blaine.gmane.org ([80.91.229.8]:38391 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855AbZCYLfK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 07:35:10 -0400
Received: from public by hugh.gmane.org with local (Exim 4.63)
	(envelope-from <public@hugh.gmane.org>)
	id 1LmRNo-0006xu-QR
	for linux-wireless@vger.kernel.org; Wed, 25 Mar 2009 12:34:56 +0100
Date: Wed, 25 Mar 2009 12:34:37 +0100
From: Evgeni Golov <sargentd@die-welt.net>
To: "Luis R. Rodriguez"
	<public-mcgrof-Re5JQEeQqe8AvxtiuMwx3w@hugh.gmane.org>
Cc: Debian Devel
	<public-debian-devel-0aAXYlwwYIJuHlm7Suoebg@hugh.gmane.org>,
	"linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org"
	<public-linux-wireless-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>,
	Tim Gardner
	<public-tim.gardner-Z7WLFzj8eWMS+FvcfC7Uqw@hugh.gmane.org>
Subject: Re: [renamed] Debian crda?
In-Reply-To: <43e72e890903250051j44955276j42fce045c5079b87@mail.gmail.com>
References: <43e72e890903250009hbe7bcfal546dddf731820b8e@mail.gmail.com>
	<e13a36b30903250039h55c8a01cg9dada9256bc8b1ae@mail.gmail.com>
	<43e72e890903250047o6a4ed5cfm4ebb849013e9d571@mail.gmail.com>
	<43e72e890903250051j44955276j42fce045c5079b87@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20090325113438.97D911FD1F@chi.die-welt.net> (sfid-20090325_123516_672956_E90697A6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Wed, 25 Mar 2009 00:51:41 -0700 Luis R. Rodriguez wrote:

> On Wed, Mar 25, 2009 at 12:47 AM, Luis R. Rodriguez <mcgrof-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > On Wed, Mar 25, 2009 at 12:39 AM, Paul Wise <pabs-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org> wrote:
> >> On Wed, Mar 25, 2009 at 4:09 PM, Luis R. Rodriguez <mcgrof-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >>
> >>> Last time I poked them it seemed it was not easy to figure out how to
> >>> deal with, if at all, the optional but recommended RSA signature stuff
> >>> [1] with the DFSG.
> >>>
> >>> [1] http://wireless.kernel.org/en/developers/Regulatory#RSADigitalSignature
> >>
> >> What is the percieved DFSG/RSA conflict? I can't detect any based on
> >> that section of the page.
> >
> > Thanks Paul, then its just a matter of packaging. There is an
> > debian-example/ directory with a cdbs example of how to package for
> > wireless-regdb and crda if anyone is up for it.
> 
> And as its probably best to coordinate with Ubuntu, they have a
> wireless-crda package which combines both into one package. Its
> shipping for Jaunty.

I'd be interested in CRDA, but:
- I don't like CDBS ;)
- I'm not a DD (yet, *waiting*), so I'd need a sponsor
- Prolly this should be done under the pkg-wpa umbrella

-- 
Bruce Schneier Fact Number 731:
Bruce Schneier knows at least 0x09f911029d74e35bd84156c5635688c0 other
ways to crack HD-DVD encryption.

