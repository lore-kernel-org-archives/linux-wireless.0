Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:36359 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762880AbZANQsx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2009 11:48:53 -0500
Subject: Re: Marvell 88w8385 Support
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: tsr <tsr.offentlig@tsr.se>, linux-wireless@vger.kernel.org
In-Reply-To: <20090113145213.GA3623@tuxdriver.com>
References: <496C8468.4060101@tsr.se>  <20090113145213.GA3623@tuxdriver.com>
Content-Type: text/plain
Date: Wed, 14 Jan 2009 11:47:34 -0500
Message-Id: <1231951654.14909.22.camel@localhost.localdomain> (sfid-20090114_174858_058911_F49AD2FF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-01-13 at 09:52 -0500, John W. Linville wrote:
> On Tue, Jan 13, 2009 at 01:09:12PM +0100, tsr wrote:
> > Hi,
> >
> > I have a FSG-3 that includes a Marvell 88w8385 card. I wonder if there  
> > is support for it in recent kernels. According to  
> > http://marc.info/?l=linux-wireless&m=123178916308198&w=2 (search for  
> > 8385) there seems to be support but I don't want to start messing around  
> > with kernels and stuff without being sure.
> 
> That driver is for SDIO hardware.  It looks like your FSG-3 has
> mini-PCI?  Either way, we don't have a driver merged yet that would
> cover your hardware.

Looks like it's a CB35, which is actually an 88w8335 MiniPCI card.
Would be supported by the mwl8k driver ideally.  I've started on trying
to add support to mwl8k for the 8335 parts, but we'll need to split the
driver so that we can create IO hooks for the different parts.  It'll be
a bit, but we'll get there.

Dan


