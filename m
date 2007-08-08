Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:37012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032AbXHHLWy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 07:22:54 -0400
Subject: Re: Marvell pci wifi chips
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Alex Deucher <alexdeucher@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070807173431.GC3330@tuxdriver.com>
References: <a728f9f90708070921x13c1a9fem8f7bbf3fe77756d@mail.gmail.com>
	 <20070807173431.GC3330@tuxdriver.com>
Content-Type: text/plain
Date: Wed, 08 Aug 2007 07:19:14 -0400
Message-Id: <1186571954.10612.1.camel@xo-13-A4-25.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-08-07 at 13:34 -0400, John W. Linville wrote:
> On Tue, Aug 07, 2007 at 12:21:02PM -0400, Alex Deucher wrote:
> > Is anyone working on a driver for the marvell pci libertas chips
> > (8335, 8300, 8310, etc.) or know of someone who is?  I've got several
> > of these cards not doing anything at the moment if someone is
> > interested in one.  It seems there are several drivers floating
> > around:
> > 
> > - mrv8k driver (http://www.saillard.org/linux/mrv8k/)
> > - openbsd malo driver (http://www.openbsd.org/cgi-bin/man.cgi?query=malo)
> > - marvell GPL driver (http://johannes.sipsolutions.net/files/marvell.tar.bz2)
> > 
> > Reading through the linux-wireless archive, several people seemed to
> > indicate there was work going on, but I have not been able to find any
> > information on that other than Holger's CF libertas integration.  I
> > and others have asked before, but there seems to be some confusion as
> > to the whole libertas line and their relative compatibility.  Just
> > curious.
> 
> I think I saw discussion lately to the effect that the PCI devices are
> not currently supported, and that they likely could be supported by
> simply implementing a PCI front-end to the core of the libertas code.
> I think Holger is the person most likely to know for sure.

Well, it depends if the firmware interface is similar to the 838x line.
These are fullmac chips, but I'm unsure if the 8335/8300/8310 are
anything like that.  ISTR they are more softmac-like, and therefore the
firmware interface would be quite different.  Might need a different
driver for them.

Dan

> I've got cards like that too -- would love for you to get them
> working... :-)
> 
> John

