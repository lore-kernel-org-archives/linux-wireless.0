Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2554 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892AbYHLNcZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Aug 2008 09:32:25 -0400
Date: Tue, 12 Aug 2008 09:03:23 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Jan Willies <jan@willies.info>, linux-wireless@vger.kernel.org
Subject: Re: unable to associate with WPA-AP - rt2x00-2.1.8
Message-ID: <20080812130323.GB27672@tuxdriver.com> (sfid-20080812_153229_083855_1F14CC8F)
References: <489FF6A8.9030204@willies.info> <200808112017.58980.IvDoorn@gmail.com> <48A084F7.6070206@willies.info> <200808112346.20015.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200808112346.20015.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 11, 2008 at 11:46:19PM +0200, Ivo van Doorn wrote:
> On Monday 11 August 2008, Jan Willies wrote:
> > Ivo van Doorn wrote:
> > > On Monday 11 August 2008, Jan Willies wrote:
> > >> I'm using Fedore9 and since the last update I cannot associate my rt2500pci card anymore, it's running into a timeout. I'm not seeing any log entries on the AP.
> > >>
> > >> rt2500pci is version 2.1.8
> > > 
> > > I think this should have been fixed by patch:
> > > http://lkml.org/lkml/2008/7/31/35
> > > 
> > > But I don't know if John has merged that patch to FC9 yet.

FWIW, someone else is (supposedly) now handling pushing fixes to
Fedora.  Unfortunately I don't see any evidence that many recent
fixes have been pushed there...

> I was planning to send the patch for 2.6.26 seperately, but saw that John already
> converted the patch correctly.
> I'll double check where the patches are heading, and one is at least moving
> toways 2.6.26-stable.

I don't think one is.  You should probably send something to
stable@kernel.org.

John
-- 
John W. Linville
linville@tuxdriver.com
