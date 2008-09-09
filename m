Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:35830 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbYIIVqt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 17:46:49 -0400
Date: Tue, 9 Sep 2008 14:44:47 -0700
To: Tomas Winkler <tomasw@gmail.com>
Cc: Dave <kilroyd@googlemail.com>, Pavel Roskin <proski@gnu.org>,
	Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	orinoco-devel@lists.sourceforge.net
Subject: Re: [PATCH 01/19] orinoco: Add ESSID specific scanning for Agere fw
Message-ID: <20080909214447.GA29934@bougret.hpl.hp.com> (sfid-20080909_234704_669571_09C43C95)
Reply-To: jt@hpl.hp.com
References: <1217672073-7094-2-git-send-email-kilroyd@gmail.com> <1217825304.10989.20.camel@dv> <1217864060.3139.10.camel@localhost.localdomain> <20080805162238.GA6294@bougret.hpl.hp.com> <20080902230621.GA28885@bougret.hpl.hp.com> <1220878110.2369.3.camel@dv> <20080908183203.GA7090@bougret.hpl.hp.com> <48C6C262.7010803@gmail.com> <20080909193303.GA28424@bougret.hpl.hp.com> <1ba2fa240809091420w11d3a317vdbb863c85c30e59e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240809091420w11d3a317vdbb863c85c30e59e@mail.gmail.com>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 10, 2008 at 12:20:26AM +0300, Tomas Winkler wrote:
> On Tue, Sep 9, 2008 at 10:33 PM, Jean Tourrilhes <jt@hpl.hp.com> wrote:
> > On Tue, Sep 09, 2008 at 07:37:22PM +0100, Dave wrote:
> >>
> >> Thanks for finding that Jean! I've double checked, and agree it's the right
> >> fix.
> >>
> >> FWIW, I've verified this compiles and (still) works as expected on my 32
> >> bit system.
> >
> >        My pleasure. Sorry for beeing so late...
> >        By the way, I would not mind people looking at Wireless Tools
> > v30.pre7 so that I can get feedback and make a final release.
> >
> My little report :)
> I've tested the power (save) command. It fixes the issues in 'saving'
> parameter  that are in v29.
> Tomas

	Thanks for testing. The fact that this bug went into v29 show
how many people are using that feature...

	Jean
