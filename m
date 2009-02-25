Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:50753 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758207AbZBYChd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 21:37:33 -0500
Date: Wed, 25 Feb 2009 03:37:30 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH,RFC] initial mwl8k driver for marvell topdog wireless
Message-ID: <20090225023730.GC17040@xi.wantstofly.org> (sfid-20090225_033746_326365_0217DC3A)
References: <20081216025542.GO18056@xi.wantstofly.org> <1229443806.7307.34.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1229443806.7307.34.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 16, 2008 at 11:10:06AM -0500, Dan Williams wrote:

> > Attached is an initial version of the mwl8k driver for Marvell 88w8xxx
> > PCI/PCIe wireless parts (against 2.6.27.1).  This version was written
> > and tested against the 88w8687 (802.11b/g), but it shouldn't be hard to
> > extend the support to other parts in the 8xxx series, since the firmware
> > interface is very similar between parts.
> > 
> > There's an occasional timeout warning with mwl8k_stop(), and hardware
> > crypto is still a work-in-progress, but other than that it looks pretty
> > stable.
> > 
> > Feedback appreciated!

Hi Dan,


> Oooh, thanks for the Christmas present.  Just in time for the holidays.
> Is there a git repo somewhere that we could all base off of, so we don't
> have to deal with patches to patches to patches until it gets into
> wireless-testing?

There is no git repo for now, but if e.g. it's held over for 2.6.31
it shouldn't be a problem to create one.

In the meanwhile, please send me any patches you have and I'll deal
with them.


thanks,
Lennert
