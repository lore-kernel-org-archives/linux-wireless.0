Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:59010 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888AbaETK2z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 06:28:55 -0400
Date: Tue, 20 May 2014 06:26:24 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
To: Johannes Berg <johannes@sipsolutions.net>
cc: linux-wireless@vger.kernel.org
Subject: Re: if i deselect PCIEPORTBUS, why are iwlwifi PCIE modules still
 being compiled?
In-Reply-To: <1400581259.4474.3.camel@jlt4.sipsolutions.net>
Message-ID: <alpine.LFD.2.11.1405200625520.3646@localhost> (sfid-20140520_122858_194819_4C6E41FA)
References: <alpine.LFD.2.11.1405200342050.10462@localhost>   (sfid-20140520_101149_157876_1874D563) <1400574452.4474.2.camel@jlt4.sipsolutions.net>  <alpine.LFD.2.11.1405200526530.12158@localhost> <1400581259.4474.3.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 20 May 2014, Johannes Berg wrote:

> On Tue, 2014-05-20 at 05:28 -0400, Robert P. J. Day wrote:
>
> > > The whole driver depends on CONFIG_PCI, maybe it should depend on
> > > something more PCIe specific, but that wasn't easy to sort out, and
> > > the APIs it needs aren't PCIe specific afaict.
> >
> >   ok, i'll have to think about that for a few minutes. am i at least
> > correct in my understanding that, technically, the kernel config
> > option PCIEPORTBUS is supposed to control whether one wants basic PCIE
> > support or not?
>
> I don't know, sorry.

  ok, i think i'll go hassle people on the linux-pci list about this,
thanks for your patience.

rday

-- 

========================================================================
Robert P. J. Day                                 Ottawa, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
