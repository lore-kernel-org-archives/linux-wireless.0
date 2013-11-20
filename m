Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45487 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab3KTLjv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Nov 2013 06:39:51 -0500
Message-ID: <1384947587.14295.6.camel@jlt4.sipsolutions.net> (sfid-20131120_123954_696076_75AF1763)
Subject: Re: QoS Data packets causing massive packet loss in
 ieee80211_sta_manage_reorder_buf.
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: Blaise Gassend <blaise@suitabletech.com>,
	linux-wireless@vger.kernel.org,
	Catalin Drula <catalin@suitabletech.com>,
	Alap Modi <amodi@arubanetworks.com>
Date: Wed, 20 Nov 2013 12:39:47 +0100
In-Reply-To: <20131120112535.GC6993@magnum.frso.rivierawaves.com> (sfid-20131120_122610_761173_F299F154)
References: <CAPvVjisu-xcZsqHgcTEKsCJFuESDFO-_0KwkgxffyejemHJZcA@mail.gmail.com>
	 <1384937328.14295.3.camel@jlt4.sipsolutions.net>
	 <CAPvVjiu55=nscHa-Mpff_LL-Y0v6XHEGx0K7rpCVU9nRiKfaXA@mail.gmail.com>
	 <20131120110157.GA6993@magnum.frso.rivierawaves.com>
	 <1384945569.14295.5.camel@jlt4.sipsolutions.net>
	 <20131120111654.GB6993@magnum.frso.rivierawaves.com>
	 <20131120112535.GC6993@magnum.frso.rivierawaves.com>
	 (sfid-20131120_122610_761173_F299F154)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-11-20 at 12:25 +0100, Karl Beldan wrote:

> > > > > > http://p.sipsolutions.net/d00799dd2201676a.txt
> > > > > 
> > > > > This patch works like a charm for my current predicament. But is it
> > > > > actually written somewhere that multicast packets can't be aggregated?
> > > > > I can't find any place that says they can't, but I'm not authoritative
> > > > > by any means.
> > > > > 
> > > > There's a chapter "A-MPDU aggregation of group addressed data frames" in
> > > > the specs, however I haven't seen this yet.
> > > 
> > > Even then though, I don't think there would be any block-ack session,
> > > and thus you wouldn't be able to use the reorder buffer anyway, right?
> > > 
> > I think so.
> >  
> Except maybe for 802.11aa GCR (groupcast with retries) ..

But that will probably need much more work anyway ... :)

johannes

