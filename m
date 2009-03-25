Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:51532 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763825AbZCYRhr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 13:37:47 -0400
From: Kel Modderman <kel@otaku42.de>
To: debian-devel@lists.debian.org
Subject: Re: [renamed] Debian crda?
Date: Thu, 26 Mar 2009 03:37:37 +1000
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Tim Gardner <tim.gardner@canonical.com>
References: <43e72e890903250009hbe7bcfal546dddf731820b8e@mail.gmail.com> <43e72e890903250047o6a4ed5cfm4ebb849013e9d571@mail.gmail.com> <43e72e890903250051j44955276j42fce045c5079b87@mail.gmail.com>
In-Reply-To: <43e72e890903250051j44955276j42fce045c5079b87@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200903260337.37783.kel@otaku42.de> (sfid-20090325_183755_097258_8D534C5D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 25 March 2009 17:51:41 Luis R. Rodriguez wrote:
> On Wed, Mar 25, 2009 at 12:47 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> > On Wed, Mar 25, 2009 at 12:39 AM, Paul Wise <pabs@debian.org> wrote:
> >> On Wed, Mar 25, 2009 at 4:09 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
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

The example packaging needs some love, I think. I don't see it as a great
reference to the eventual packaging material that would enter Debian.

> 
> And as its probably best to coordinate with Ubuntu, they have a
> wireless-crda package which combines both into one package. Its
> shipping for Jaunty.

And that's the only way to sanely package it (by combining the two pieces
upstream splits) as show by Fedora also choosing that route.

Luis why can't CRDA and regd simply be released in same tarball considering
they have such a strong relationship with eachother due to the openssl stuff?

Thanks, Kel.
