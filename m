Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:15776 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201AbZLNR1F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 12:27:05 -0500
Received: by fg-out-1718.google.com with SMTP id e21so45191fga.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2009 09:27:04 -0800 (PST)
Subject: Re: mac80211 or ath9k? No connect to other band after resume
From: ASIC Felix <ic.felix@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1260811456.2442.422.camel@johannes.local>
References: <1260811290.2612.21.camel@darkslate>
	 <1260811456.2442.422.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 14 Dec 2009 09:26:58 -0800
Message-Id: <1260811618.2612.24.camel@darkslate>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-12-14 at 18:24 +0100, Johannes Berg wrote:
> On Mon, 2009-12-14 at 09:21 -0800, ASIC Felix wrote:
> > Hi,
> > 
> > I found a suspend/resume bug.
> > Kernel 2.6.32-wl-45997-gf02c03a master-2009-12-07
> > 
> > To reproduce:
> > - connect to 2G network (my office)
> > - pm-suspend
> > - resume (at home, wpa_supplicant.conf only has 5G home network)
> > - laptop only scans 2G, never sees 5G AP
> > - workaround: 
> >     /etc/init.d/network stop
> >     rmmod bla bla bla
> >     modprobe ath9k
> >     /etc/init.d/network start
> > - now laptop reconnects
> 
> I'd guess regulatory -- enable debugging for that please.


will do.

Felix

