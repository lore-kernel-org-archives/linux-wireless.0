Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53291 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969AbYLPQaL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2008 11:30:11 -0500
Date: Tue, 16 Dec 2008 11:16:58 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH,RFC] initial mwl8k driver for marvell topdog wireless
Message-ID: <20081216161658.GC3636@tuxdriver.com> (sfid-20081216_173015_245187_3F58C4A0)
References: <20081216025542.GO18056@xi.wantstofly.org> <1229443806.7307.34.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1229443806.7307.34.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 16, 2008 at 11:10:06AM -0500, Dan Williams wrote:
> On Tue, 2008-12-16 at 03:55 +0100, Lennert Buytenhek wrote:
> > Hi all,
> > 
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
> 
> Oooh, thanks for the Christmas present.  Just in time for the holidays.
> Is there a git repo somewhere that we could all base off of, so we don't
> have to deal with patches to patches to patches until it gets into
> wireless-testing?

I wouldn't worry too much about that.  The better questions is where
do we get firmware?

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
