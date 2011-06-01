Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp6.freeserve.com ([193.252.22.190]:47662 "EHLO
	smtp6.freeserve.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696Ab1FAMI6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 08:08:58 -0400
Date: Wed, 1 Jun 2011 13:08:42 +0100
From: Chris Vine <chris@cvine.freeserve.co.uk>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>,
	Michael =?ISO-8859-1?B?QvxzY2g=?= <mb@bu3sch.de>,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: b43 error under heavy load
Message-ID: <20110601130842.077da1c3@boulder.homenet> (sfid-20110601_140901_467560_18D3E532)
In-Reply-To: <BANLkTin_RnMV3KnGS4qYPtMVxCuW=Vj7mg@mail.gmail.com>
References: <4CEAB969.20702@lwfinger.net>
	<1290451982.20888.2.camel@maggie>
	<4CEAC095.7020706@lwfinger.net>
	<BANLkTimjRA5CsSDp_+LrGq8PNgaR4JFD=w@mail.gmail.com>
	<4DC9853A.1090508@lwfinger.net>
	<BANLkTimBpGRxfidpE4hYCVscmX-Hy5q5jw@mail.gmail.com>
	<BANLkTi=TohOdjurvgqZT8=GXKbWfNe4v+w@mail.gmail.com>
	<20110601114839.433ae42d@boulder.homenet>
	<BANLkTin_RnMV3KnGS4qYPtMVxCuW=Vj7mg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 1 Jun 2011 12:56:22 +0200
Rafał Miłecki <zajec5@gmail.com> wrote:
> 2011/6/1 Chris Vine <chris@cvine.freeserve.co.uk>:
> > On Wed, 1 Jun 2011 11:23:45 +0200
> > Rafał Miłecki <zajec5@gmail.com> wrote:
> >> AFAIK to enable this debugging you only need to:
> >> echo 1 > /sys/kernel/debug/b43/phy0/debug_dmaverbose
> >
> > I don't have a /sys/kernel/debug directory with a running 3.0.0-rc1
> > kernel, so it appears that b43 debugging (which I do have enabled)
> > doesn't use it.
> 
> mount -t debugfs none /sys/kernel/debug/

Ah, so I need to compile in debugfs.  That isn't/wasn't necessary for
the DMA error debugging.  I am surprised that debugfs enables you to
alter kernel debugging levels on the fly (I thought it was a
passive logging mechanism for kernel state), but you live and learn.

I will compile in debugfs, but I don't expect to have any rapid results
for you. With 3 and a half hours of streaming yesterday it happened
once.  I won't be able to do much testing by way of transferring files
over the LAN for a while either (I imagine that would provide greater
stress testing).

Chris


