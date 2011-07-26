Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp6.freeserve.com ([193.252.22.191]:1658 "EHLO
	smtp6.freeserve.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab1GZJ2v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2011 05:28:51 -0400
Date: Tue, 26 Jul 2011 10:28:50 +0100
From: Chris Vine <chris@cvine.freeserve.co.uk>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>,
	Michael =?ISO-8859-1?B?QvxzY2g=?= <mb@bu3sch.de>,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: b43 error under heavy load
Message-ID: <20110726102850.07e851b2@boulder.homenet> (sfid-20110726_112855_586393_3FB15CA1)
In-Reply-To: <BANLkTi=j7gZq2U8QOXBLAPzN4_9DQUm7=A@mail.gmail.com>
References: <4CEAB969.20702@lwfinger.net>
	<1290451982.20888.2.camel@maggie>
	<4CEAC095.7020706@lwfinger.net>
	<BANLkTimjRA5CsSDp_+LrGq8PNgaR4JFD=w@mail.gmail.com>
	<4DC9853A.1090508@lwfinger.net>
	<BANLkTimBpGRxfidpE4hYCVscmX-Hy5q5jw@mail.gmail.com>
	<BANLkTi=TohOdjurvgqZT8=GXKbWfNe4v+w@mail.gmail.com>
	<20110601114839.433ae42d@boulder.homenet>
	<BANLkTin_RnMV3KnGS4qYPtMVxCuW=Vj7mg@mail.gmail.com>
	<20110601130842.077da1c3@boulder.homenet>
	<BANLkTi=2xYrrjEdHuYCKFKy4H2EXoUGQuQ@mail.gmail.com>
	<20110601160101.75e30b3d@boulder.homenet>
	<BANLkTim9pQc+yxdQLSL1-6VNiyM6_tvJ6g@mail.gmail.com>
	<20110601184931.499557c6@boulder.homenet>
	<BANLkTi=Cm1o8HVqugC6JNooP8h+HpJ=aRQ@mail.gmail.com>
	<20110601190929.244c57ed@boulder.homenet>
	<BANLkTi=j7gZq2U8QOXBLAPzN4_9DQUm7=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 1 Jun 2011 20:10:44 +0200
Rafał Miłecki <zajec5@gmail.com> wrote:
> 2011/6/1 Chris Vine <chris@cvine.freeserve.co.uk>:
> > On Wed, 1 Jun 2011 20:03:56 +0200
> > Rafał Miłecki <zajec5@gmail.com> wrote:
> >> 2011/6/1 Chris Vine <chris@cvine.freeserve.co.uk>:
> >> > The one which failed caused the cessation of
> >> > wireless traffic, and was accompanied by the debug log reports of
> >> > out of order TX status earlier referred to, and with only one
> >> > single report
> >>
> >> As I said, I don't really suspect any relation between full TX ring
> >> and out of order problems anymore.
> >>
> >> But it won't hurt to ask just in case:
> >> Did you see relation between this single "Stopped TX ring 1" and
> >> massive out of order messages? Did out of order messages starter
> >> right after "Stopped TX ring 1" one?
> >
> > The "Stopped TX ring 1" message was near the end (but not at the
> > end) of the out of order messages. It was definitely not at the
> > beginning of the out of order messages.
> 
> Thanks. That confirmed for me, there is no relation.

I have tested with the newer firmware (from broadcom-wl-5.10.56.27.3),
and I get the same failure with "Out of order TX status report on DMA
ring 1" after transferring about 380MB of data at full speed.

Chris


