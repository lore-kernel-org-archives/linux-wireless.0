Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40989 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756228AbZIKTpc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 15:45:32 -0400
Date: Fri, 11 Sep 2009 15:35:42 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org, Kel Modderman <kel@otaku42.de>
Subject: Re: Questions about regulatory domain & passive scanning
Message-ID: <20090911193542.GK2622@tuxdriver.com>
References: <200909111427.39974.hs4233@mail.mn-solutions.de> <43e72e890909111136r67a305b9qc3e78a7dcb205d@mail.gmail.com> <69e28c910909111226s48ac1db9ya8fe2cce54861c1e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <69e28c910909111226s48ac1db9ya8fe2cce54861c1e@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 11, 2009 at 09:26:11PM +0200, Gábor Stefanik wrote:
> On Fri, Sep 11, 2009 at 8:36 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
> > On Fri, Sep 11, 2009 at 5:27 AM, Holger Schurig
> > <hs4233@mail.mn-solutions.de> wrote:
> >> Hi !
> >>
> >> I'm playing with regulatory domain using wireless-testing, iw,
> >> crda and ath5 on Debian. Here are some observations:
> >>
> >> 1) Debian sucks here
> >
> > We've tried a few times to poke them and after some thread exchanges
> > and some changes to wirless-regdb and crda due to concerns over the
> > signing stuff due to the DFSG in account for these discussions it
> > seems some stuff was packaged but not sure where it went. Kel, are you
> > aware of the status in this regard on Debian?
> 
> Well, if the problem is signing, then they are always free to package
> a patched crda that accepts unsigned or self-signed databases; AFAIK
> GPL doesn't prohibit that (though it kinda defeats the purpose of
> crda).

I disagree about that defeating the purpose -- the purpose is to put
the decision making into userland.  The signing is a configuration
issue, allowing distributions to have "trusted" configuration sources
by default.
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
