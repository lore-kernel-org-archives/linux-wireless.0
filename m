Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:49884 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab3KTLCg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Nov 2013 06:02:36 -0500
Received: by mail-ea0-f175.google.com with SMTP id z10so1564221ead.34
        for <linux-wireless@vger.kernel.org>; Wed, 20 Nov 2013 03:02:35 -0800 (PST)
Date: Wed, 20 Nov 2013 12:01:57 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Blaise Gassend <blaise@suitabletech.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Catalin Drula <catalin@suitabletech.com>,
	Alap Modi <amodi@arubanetworks.com>
Subject: Re: QoS Data packets causing massive packet loss in
 ieee80211_sta_manage_reorder_buf.
Message-ID: <20131120110157.GA6993@magnum.frso.rivierawaves.com> (sfid-20131120_120246_351121_8250119E)
References: <CAPvVjisu-xcZsqHgcTEKsCJFuESDFO-_0KwkgxffyejemHJZcA@mail.gmail.com>
 <1384937328.14295.3.camel@jlt4.sipsolutions.net>
 <CAPvVjiu55=nscHa-Mpff_LL-Y0v6XHEGx0K7rpCVU9nRiKfaXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAPvVjiu55=nscHa-Mpff_LL-Y0v6XHEGx0K7rpCVU9nRiKfaXA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 20, 2013 at 02:15:27AM -0800, Blaise Gassend wrote:
> Hi Johannes,
> 
> Thanks for the quick reply!
> 
> > I think we just need to skip reorder processing for multicast, since
> > they won't be aggregated anyway?
> >
> > http://p.sipsolutions.net/d00799dd2201676a.txt
> 
> This patch works like a charm for my current predicament. But is it
> actually written somewhere that multicast packets can't be aggregated?
> I can't find any place that says they can't, but I'm not authoritative
> by any means.
> 
There's a chapter "A-MPDU aggregation of group addressed data frames" in
the specs, however I haven't seen this yet.

 
Karl
