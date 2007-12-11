Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35678
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752453AbXLKEvk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 23:51:40 -0500
Date: Mon, 10 Dec 2007 20:51:39 -0800 (PST)
Message-Id: <20071210.205139.262078026.davem@davemloft.net> (sfid-20071211_045145_279704_A882F9F6)
To: dcbw@redhat.com
Cc: jt@hpl.hp.com, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
Subject: Re: [RFC PATCH] introduce WEXT scan capabilities
From: David Miller <davem@davemloft.net>
In-Reply-To: <1197346930.16807.7.camel@localhost.localdomain>
References: <1197307403.18585.10.camel@localhost.localdomain>
	<20071210.161144.190139513.davem@davemloft.net>
	<1197346930.16807.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Williams <dcbw@redhat.com>
Date: Mon, 10 Dec 2007 23:22:10 -0500

> On Mon, 2007-12-10 at 16:11 -0800, David Miller wrote:
> > From: Dan Williams <dcbw@redhat.com>
> > Date: Mon, 10 Dec 2007 12:23:23 -0500
> > 
> > > Is this an unconditional NAK for any changes to WEXT?
> > 
> > Well, it is at least completely proven that you cannot
> > extend the structures without crapping all over random
> > areas of the stack space of the user application.
> > 
> > So at a minimum you're going to get NAKs for any patch
> > that does things that way.
> 
> So would another WEXT subcommand be acceptable to you?

I might find using the existing spare space bearable, but
even that is a stretch.

We need to completely deprecate WEXT as fast as possible
and adding new features to it won't help that.
