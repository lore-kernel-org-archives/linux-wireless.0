Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta21.charter.net ([216.33.127.81]:61759 "EHLO
	mta21.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935406Ab3FTAD7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 20:03:59 -0400
Date: Wed, 19 Jun 2013 20:03:56 -0400
From: rlwkayaker <rlwkayaker@charter.net>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Howto remove rfkill from kernel
Message-ID: <20130619200356.741ec084@compuzoo> (sfid-20130620_020405_910767_0AFB94FE)
In-Reply-To: <1371682734.1051.0.camel@dcbw.foobar.com>
References: <20130619133638.3d183a00@compuzoo>
	<1371682734.1051.0.camel@dcbw.foobar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 19 Jun 2013 17:58:54 -0500
Dan Williams <dcbw@redhat.com> wrote:

> On Wed, 2013-06-19 at 13:36 -0400, rlwkayaker wrote:
> > The rfkill "feature" has rendered the internal wireless of my
> > Averatec 3260 laptop unusable.  It works fine with earlier
> > kernels without this "feature".  How do I remove the rfkill
> > "feature" from a custom built kernel?
> 
> Best thing to do is figure out why this is happening, and fix
> it.  What kernels worked?  What kernels fail?  What wifi card
> do you have, and was it the card the laptop originally came
> with?
> 
> Dan
> 
I have been using 2.6.32-5-686 successfully with Debian
Squeeze.  Earlier kernels native to Debian Lenny and Etch also
worked well.  I tried to update to Debian Wheezy which uses
3.2.0.4 and ran into many problems, including the rfkill
"feature".  I gave up on Wheezy and I tried Gentoo, with it's
3.? kernel and the same rfkill problem, among others. I am
currently using 3.7.10-antiX which works very well in this
laptop, except for rfkill "feature". rfkill has a hard block on
the wireless.  The internal card is original and uses the
rt2500pci module. I can, and do, temporarily, use a PCMCIA
wireless card in that laptop successfully and rfkill doesn't
interfere. I don't find this to be a good solution.  I would
rather go back to the internal card without the PCMCIA appendage
protruding from the side of the machine.

I have spent a lot of time trying various "fixes" identified on
the Internet.  I'm left with building a kernel without rfkill,
using the PCMCIA card or scrapping my favorite laptop because
somebody decided to put this "feature" in the kernel with
inadequate information.

Richard
