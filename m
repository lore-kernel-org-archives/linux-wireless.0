Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2184 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868AbYBETEs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2008 14:04:48 -0500
Date: Tue, 5 Feb 2008 13:59:49 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org,
	David Woodhouse <dwmw2@infradead.org>,
	libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH, take 3] libertas: clean up association debug messages
Message-ID: <20080205185949.GH4252@tuxdriver.com> (sfid-20080205_190455_425993_0944B02A)
References: <200710151255.56358.hs4233@mail.mn-solutions.de> <1201665912.28377.38.camel@shinybook.infradead.org> <200801300854.38715.hs4233@mail.mn-solutions.de> <200801301110.55581.hs4233@mail.mn-solutions.de> <20080131163940.GD6413@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080131163940.GD6413@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 31, 2008 at 11:39:40AM -0500, John W. Linville wrote:
> On Wed, Jan 30, 2008 at 11:10:55AM +0100, Holger Schurig wrote:
> > > John, I saw that you pushed one bugfix patch upstream, but not
> > > the others. Please don't apply them, I'll put all ACKed
> > > patches into the libertas-2.6 tree instead.
> > 
> > Hmm, I see that he already applied them to 
> > wireless-2.6/everything.
> 
> Only these were sent to davem:
> 
> Holger Schurig (1):
>       libertas: fix interrupt while removing driver
> 
> Ihar Hrachyshka (1):
>       libertas: fix memory alignment problems on the blackfin
> 
> The others haven't been sent anywhere yet.  If you would like I'll be happy
> to revert them and wait for dwmw2's series.

I didn't get a reply here -- shall I revert them and wait for dwmw2?

John
-- 
John W. Linville
linville@tuxdriver.com
