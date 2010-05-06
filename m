Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:62654 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345Ab0EFStz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 14:49:55 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 06 May 2010 11:49:55 -0700
Date: Thu, 6 May 2010 11:49:54 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Luis Rodriguez <Luis.Rodriguez@Atheros.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] compat-wireless: updates for orinoco
Message-ID: <20100506184954.GG4194@tux>
References: <1273012850-8359-1-git-send-email-hauke@hauke-m.de>
 <v2u43e72e891005041626n14deaca5z284f2472e909c923@mail.gmail.com>
 <1273041903.3728.0.camel@jlt3.sipsolutions.net>
 <20100505222347.GC32666@tux>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20100505222347.GC32666@tux>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 05, 2010 at 03:23:47PM -0700, Luis Rodriguez wrote:
> On Tue, May 04, 2010 at 11:45:03PM -0700, Johannes Berg wrote:
> > On Tue, 2010-05-04 at 16:26 -0700, Luis R. Rodriguez wrote:
> > 
> > > void netdev_attach_ops(struct net_device *dev,
> > >                       const struct net_device_ops *ops)
> > > {
> > > #define SET_NETDEVOP(_op) (_op ? _op : NULL)
> > 
> > isn't that like the dumbest macro ever?
> 
> That's subjective, I am lazy.

You're right this is dumb :P

  Luis
