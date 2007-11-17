Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from home.einfach.org ([80.86.92.145]:35723 "EHLO
	homebase.einfach.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528AbXKQMWc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Nov 2007 07:22:32 -0500
From: bruno randolf <bruno@thinktube.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] add missing space in error message
Date: Sat, 17 Nov 2007 21:13:26 +0900
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
References: <1195200241-25742-1-git-send-email-bruno@thinktube.com> <1195228153.8147.143.camel@johannes.berg>
In-Reply-To: <1195228153.8147.143.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200711172113.27155.bruno@thinktube.com> (sfid-20071117_122236_337062_56F6832B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 17 November 2007 00:49:13 Johannes Berg wrote:
> On Fri, 2007-11-16 at 17:04 +0900, Bruno Randolf wrote:
> > From: Bruno Randolf <br1@einfach.org>
> >
> > Signed-off-by: Bruno Randolf <bruno@thinktube.com>
>
> Huh?

ups, seems git got confused with my global and local email configuration. 
sorry.

> But I do wonder why you're seeing this message. Anything wrong with
> ath5k?

yep ;) i got this message while testing nick's patches for the 5413/14 
chipset. it sometimes fails doing the calibration.

bruno

> > ---
> >  net/mac80211/ieee80211_sta.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
> > index 2079e98..dad5edb 100644
> > --- a/net/mac80211/ieee80211_sta.c
> > +++ b/net/mac80211/ieee80211_sta.c
> > @@ -2644,7 +2644,7 @@ void ieee80211_scan_completed(struct ieee80211_hw
> > *hw) local->sta_scanning = 0;
> >
> >  	if (ieee80211_hw_config(local))
> > -		printk(KERN_DEBUG "%s: failed to restore operational"
> > +		printk(KERN_DEBUG "%s: failed to restore operational "
> >  		       "channel after scan\n", dev->name);


