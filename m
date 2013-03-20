Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from avasout07.plus.net ([84.93.230.235]:41226 "EHLO
	avasout07.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361Ab3CTQQg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 12:16:36 -0400
Date: Wed, 20 Mar 2013 16:10:49 +0000
From: Chris Vine <chris@cvine.freeserve.co.uk>
To: isedev@gmail.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: [RFC/RFT] b43: A fix for DMA transmission sequence errors
Message-ID: <20130320161049.06f01a7d@laptop.homenet> (sfid-20130320_171640_513096_A007229E)
In-Reply-To: <2272126.rjuG7RkCA8@wks001.ise.net>
References: <51421afb.xUa3KbaBuvmUk4RG%Larry.Finger@lwfinger.net>
	<4518745.W5blfs9sIi@wks001.ise.net>
	<5149CD68.7070603@lwfinger.net>
	<2272126.rjuG7RkCA8@wks001.ise.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 20 Mar 2013 16:04:29 +0100
ISE Development <isedev@gmail.com> wrote:

> On Wednesday 20 Mar 2013 09:53:28 Larry Finger wrote:
> > On 03/20/2013 06:26 AM, ISE Development wrote:
> > > Did you get a chance to validate this patch?
> > > 
> > > So far on my system, it has been running for over week without
> > > problems (over 15GB of traffic).
> > 
> > I have been using the patch, but I am testing rtlwifi drivers quite
> > heavily at the moment, thus b43 has had limited usage. In fact, I
> > was waiting to get a report from you before pushing the patch. It
> > is ready to go.
> > 
> > How frequently do you get the automatic reset?
> > 
> > Larry
> 
> At least 3 or 4 per second when exceeding 2Mbit/s, otherwise around
> 1-2 per 10 second interval. The card was literally unusable without
> the patch.

For me, much less.  At full speed, about one reset per 500MBytes.  In
fact, the resets seem to depend on the number of bytes passed rather
than the speed of itself.

Chris
