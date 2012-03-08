Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48613 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753889Ab2CHWZk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2012 17:25:40 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1S5lmE-0004KV-Qt
	for linux-wireless@vger.kernel.org; Thu, 08 Mar 2012 23:25:39 +0100
Received: from f053208081.adsl.alicedsl.de ([78.53.208.81])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 08 Mar 2012 23:25:38 +0100
Received: from drahemmaps by f053208081.adsl.alicedsl.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 08 Mar 2012 23:25:38 +0100
To: linux-wireless@vger.kernel.org
From: Martin Schleier <drahemmaps@gmx.net>
Subject: Re: Google Summer of Code 2012 - Application for the Linux Foundation submitted
Date: Thu, 8 Mar 2012 22:25:28 +0000 (UTC)
Message-ID: <loom.20120308T231306-198@post.gmane.org> (sfid-20120308_232544_066567_1619AB30)
References: <4F59274D.7060708@gmail.com> <CAB=NE6Wiwo2Cj8-UMqGQik7Hv=LMZ=+9ifa8Qia8OPuXFgEyKw@mail.gmail.com> <4F592BE0.70706@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Till Kamppeter <till.kamppeter@...> writes:

> 
> On 03/08/2012 10:45 PM, Luis R. Rodriguez wrote:
> >
> > So one idea I had was working on open firmware for ath9k_htc. We don't
> > have the resources to open that up but can likely provide under NDA
> > source code to let it get cleaned up for public release. If this is
> > reasonable I'll throw it on.
> >
> 
> OK, please do it.
> 
>     Till

Wait wait wait... qualcomm/Atheros does not have the resources, so how on earth
should a student (or students) actually do that?

Given the TODO over at
<http://wireless.kernel.org/en/users/Drivers/ath9k_htc#TODO> [Scroll down till
you get "fixed in the firmware. ]. This would be at least one years of full-time
work for a small team of trained code-monkey and therefore this "project" is
highly unrealistic.

Maybe we should stick to something less complicated.

Like extending PID to use MCS rates, or implementing a TPC control algorithm
[this is stuff, every drivers could use].


