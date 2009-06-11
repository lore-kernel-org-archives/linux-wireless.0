Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:10273 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759794AbZFKKmS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2009 06:42:18 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2009 03:42:22 -0700
Date: Thu, 11 Jun 2009 16:10:57 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <mcgrof@gmail.com>
Subject: Re: [RFT 2/3] ath9k: port to cfg80211 rfkill
Message-ID: <20090611104057.GF10126@vasanth-laptop>
References: <20090602111027.460530075@sipsolutions.net> <20090602111112.191915040@sipsolutions.net> <20090610132015.GA10126@vasanth-laptop> <1244644712.26814.6.camel@johannes.local> <20090611065203.GC10126@vasanth-laptop> <1244714262.4706.7.camel@johannes.local> <20090611095949.GD10126@vasanth-laptop> <1244715003.4706.10.camel@johannes.local> <20090611103954.GE10126@vasanth-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20090611103954.GE10126@vasanth-laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 11, 2009 at 04:09:55PM +0530, Vasanth Thiagarajan wrote:
> On Thu, Jun 11, 2009 at 03:40:03PM +0530, Johannes Berg wrote:
> >
> > But that's undesirable, especially if for some reason we already know
> > it's in rfkill, we really want to know about the rfkill state even when
> > the interface is down so userspace can properly react to it and not even
> > give the user the option of bringing the interfaces up.
> >
> > Hence my suggestion of moving the start_polling().
> 
> I agree, will move it to ath9k_start().
> 
sorry, to ath_attach();
