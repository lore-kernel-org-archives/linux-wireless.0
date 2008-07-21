Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relais.videotron.ca ([24.201.245.36]:17685 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbYGUQqd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2008 12:46:33 -0400
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 21 Jul 2008 12:46:31 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
To: Dan Williams <dcbw@redhat.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	=?ISO-8859-15?Q?Stefanik_G=E1bor?= <netrolller.3d@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	lkml <linux-kernel@vger.kernel.org>
Subject: Re: Linux Wireless Mini-Summit -- Ottawa -- July 22, 2008
In-reply-to: <1216650224.22055.7.camel@localhost.localdomain>
Message-id: <alpine.LFD.1.10.0807211245020.3213@xanadu.home> (sfid-20080721_184637_843502_132082D5)
References: <20080709190915.GA8238@tuxdriver.com>
 <69e28c910807100912h30fcb57fpb4fb48b95c640f77@mail.gmail.com>
 <200807101815.27204.mb@bu3sch.de>
 <1216142191.6039.113.camel@localhost.localdomain>
 <alpine.LFD.1.10.0807151323570.12484@xanadu.home>
 <1216144711.13411.18.camel@localhost.localdomain>
 <alpine.LFD.1.10.0807151404530.12484@xanadu.home>
 <1216650224.22055.7.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 21 Jul 2008, Dan Williams wrote:

> On Tue, 2008-07-15 at 14:14 -0400, Nicolas Pitre wrote:
> > On Tue, 15 Jul 2008, Dan Williams wrote:
> > 
> > > Some of the issues with the current Marvell 83xx GPL drivers that have
> > > gotten out are (a) code style, (b) lots of commented out stuff that's
> > > never used, (c) OS abstraction that's unnecessary on Linux, (d) doesn't
> > > use mac80211, and (e) uses private ioctls.  So hopefully you're writing
> > > a new 83xx driver from scratch :)
> > 
> > Yes, this is all from scratch.  The objective for this work is to be 
> > "mainlinable".
> 
> BTW, any chance on putting up a git repo somewhere so others can poke
> around with it?  I'm quite interested in hacking on it.

Eventually, of course.  Let's discuss f2f tomorrow.


Nicolas
