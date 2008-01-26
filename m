Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout0.freenet.de ([195.4.92.90]:44425 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752956AbYAZRyl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2008 12:54:41 -0500
Received: from [195.4.92.15] (helo=5.mx.freenet.de)
	by mout0.freenet.de with esmtpa (Exim 4.68)
	(envelope-from <lynx.abraxas@freenet.de>)
	id 1JIpEl-0007ax-Df
	for linux-wireless@vger.kernel.org; Sat, 26 Jan 2008 18:54:39 +0100
Received: from p508e479c.dip.t-dialin.net ([80.142.71.156]:60256 helo=localhost)
	by 5.mx.freenet.de with esmtpsa (ID lynx.abraxas@freenet.de) (TLSv1:AES256-SHA:256) (port 587) (Exim 4.68 #9)
	id 1JIpEl-0000lK-1f
	for linux-wireless@vger.kernel.org; Sat, 26 Jan 2008 18:54:39 +0100
Date: Sat, 26 Jan 2008 18:54:38 +0100
From: lynx.abraxas@freenet.de
To: linux-wireless@vger.kernel.org
Subject: Re: What's wrong if wlan0 device is not reacting?
Message-ID: <20080126175438.GA2354@drago> (sfid-20080126_175446_269068_1BDD26D2)
References: <20071206170858.GA2008@drago> <8e6f94720712061052p105a9e82v290afb011765ba04@mail.gmail.com> <20071206214807.GB1811@drago> <43e72e890712061714i3427f558p9b94390955b0a817@mail.gmail.com> <8e6f94720712071121n234d9d23idaaf49d76b2fe227@mail.gmail.com> <43e72e890712071336v2a4a805eu6aff9ff9c10c9418@mail.gmail.com> <20071208074402.GA2508@drago> <20071210171521.GC1475@drago> <43e72e890712101126q7ba69b00sac3538a742659fbb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890712101126q7ba69b00sac3538a742659fbb@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/12/07 14:26:24, Luis R. Rodriguez wrote:
> On Dec 10, 2007 12:15 PM,  <lynx.abraxas@freenet.de> wrote:
> > On 08/12/07 08:44:02, lynx.abraxas@freenet.de wrote:
> > > Checked  this  morning  but I'm still getting errors there. Could I be missing
> > > some configuration of the build?
> > >
> >
> > Found  the problem: I seem to have gotten a cached tarball which didn't differ
> > at all. Downloading it with wget got the new one  and  that  compiles  without
> > problems under 2.6.23.9. I'm sorry for the fuzz.
> > Well testing the device with the new drivers will have to wait untill January.


I tried the tar-ball from 25-1-2008 and the device still didn't work.
So    I    got    the   USB-Hama-Stick   which   has   a   ralink   chip   and
http://www.ralinktech.com offers a driver for linux (rt73.ko) with which I got
everything to work nicely.

Thanks for the help, support and for the wirless drivers.
Lynx
