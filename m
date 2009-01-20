Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38154 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbZATXXF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2009 18:23:05 -0500
Date: Tue, 20 Jan 2009 18:23:00 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: Kyle McMartin <kyle@infradead.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Paul Hickey <paul@christianpatriot.us>,
	"stable@kernel.org" <stable@kernel.org>,
	Kyle McMartin <kyle@mcmartin.ca>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [stable] Failed Build of modules for 2.6.27.9-159
Message-ID: <20090120232300.GF17452@bombadil.infradead.org> (sfid-20090121_002322_764169_EE63D838)
References: <1232404986.3641.2.camel@localhost.localdomain> <20090120000336.GB4018@tesla> <1232433738.3696.3.camel@localhost.localdomain> <20090120194243.GC19581@tesla> <20090120200515.GA5077@kroah.com> <20090120201316.GG19581@tesla> <20090120201613.GA5313@kroah.com> <20090120211630.GJ19581@tesla> <20090120220810.GE17452@bombadil.infradead.org> <20090120223707.GA5988@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090120223707.GA5988@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 20, 2009 at 02:37:07PM -0800, Greg KH wrote:
> On Tue, Jan 20, 2009 at 05:08:10PM -0500, Kyle McMartin wrote:
> > 
> > *sigh* I don't know, and don't really want to argue about it. ;-) People
> > with backports are pretty much always going to get screwed. What's the
> > use case for wireless-testing backports? bugfixes or new features? Could
> > we improve the stable process to help wireless stuff get into 2.6.$(x-1)
> > more easily so this won't happen in the future?
> 
> I don't think we want to start adding entire new drivers to the -stable
> releases, which is what the wireless backport stuff is for, right?  That
> would really be adding new features, which is not the goal.
> 

Sorry, I meant getting bugfixes in.

r, Kyle
