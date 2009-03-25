Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33042 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333AbZCYSPp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 14:15:45 -0400
Date: Wed, 25 Mar 2009 14:12:32 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kel Modderman <kel@otaku42.de>
Cc: debian-devel@lists.debian.org,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [renamed] Debian crda?
Message-ID: <20090325181232.GA6882@tuxdriver.com> (sfid-20090325_191548_486884_52D69417)
References: <43e72e890903250009hbe7bcfal546dddf731820b8e@mail.gmail.com> <e13a36b30903250039h55c8a01cg9dada9256bc8b1ae@mail.gmail.com> <200903260345.30678.kel@otaku42.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200903260345.30678.kel@otaku42.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 26, 2009 at 03:45:30AM +1000, Kel Modderman wrote:
> On Wednesday 25 March 2009 17:39:03 Paul Wise wrote:
> > On Wed, Mar 25, 2009 at 4:09 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> > 
> > > Last time I poked them it seemed it was not easy to figure out how to
> > > deal with, if at all, the optional but recommended RSA signature stuff
> > > [1] with the DFSG.
> > >
> > > [1] http://wireless.kernel.org/en/developers/Regulatory#RSADigitalSignature
> > 
> > What is the percieved DFSG/RSA conflict? I can't detect any based on
> > that section of the page.
> 
> Hi Paul,
> 
> By default the upstream wireless-regdb tarball contains and installs a
> pre-built wireless regulatory information binary signed by John Linville's
> openssl snakeoil. It is my understanding that in Debian we would prefer to
> build the binary from its source code. That presents a problem because CRDA
> expects to see John Linville's openssl stuff. One way to work around this
> is to munge CRDA and regdb together, generate our own openssl stuff and build
> CRDA and wireless-redb at the same time. Another way to go is to do away with
> the openssl stuff during build altogether, but Luis doesn't like that, and the
> build system's need patching to support it last time I checked.

You could also patch-in support for your own signing key, provided
that would comply with whatever policies Debian has about signing keys.

Hth...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
