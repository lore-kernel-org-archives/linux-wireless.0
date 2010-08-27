Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:52309 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476Ab0H0Np3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 09:45:29 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 27 Aug 2010 06:45:25 -0700
Date: Fri, 27 Aug 2010 19:15:23 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Vivek Natarajan <Vivek.Natarajan@Atheros.com>,
	Luis Rodriguez <mcgrof@gmail.com>
Subject: Re: [PATCH] mac80211: fix offchannel queue stop
Message-ID: <20100827134523.GC3780@vasanth-laptop>
References: <1282909528.4377.8.camel@jlt3.sipsolutions.net> <20100827123054.GB3780@vasanth-laptop> <1282913816.4377.10.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1282913816.4377.10.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 27, 2010 at 06:26:56PM +0530, Johannes Berg wrote:
> On Fri, 2010-08-27 at 18:00 +0530, Vasanthakumar Thiagarajan wrote:
> 
> > > The problem, as I understand it, is that when
> > > we go offchannel while the driver has a queue
> > > stopped, the driver will likely start draining
> > > the queue and then enable it while offchannel.
> > > This in turn will enable the interface queue,
> > > and that leads to transmitting data frames on
> > > the wrong channel.
> 
> > thanks for fixing, It was me only. Somehow I forgot this.
> 
> Did I understand the issue correctly then?

Yes, you got it right.

Vasanth
