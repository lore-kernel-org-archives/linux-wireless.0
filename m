Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43433 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756362Ab3KFMUY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 07:20:24 -0500
Message-ID: <1383740420.14307.42.camel@jlt4.sipsolutions.net> (sfid-20131106_132033_477566_F7713D8C)
Subject: Re: [PATCH v2 1/5] cfg80211/mac80211: DFS setup chandef for cac
 event
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 06 Nov 2013 13:20:20 +0100
In-Reply-To: <CALhHN=pxo00fg6KYHJbw34FEP8k-6aiT2CMb5y7oRyVOyTzFZA@mail.gmail.com> (sfid-20131106_131026_149690_597A3878)
References: <1383659329-11023-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1383732564.14307.16.camel@jlt4.sipsolutions.net>
	 <CALhHN=pxo00fg6KYHJbw34FEP8k-6aiT2CMb5y7oRyVOyTzFZA@mail.gmail.com>
	 (sfid-20131106_131026_149690_597A3878)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-11-06 at 13:10 +0100, Janusz Dziedzic wrote:
> On 6 November 2013 11:09, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Tue, 2013-11-05 at 14:48 +0100, Janusz Dziedzic wrote:
> >
> >>  void cfg80211_cac_event(struct net_device *netdev,
> >> +                     struct cfg80211_chan_def *chandef,
> >
> > Jouni had a patch to make a lot of these pointers const - this one
> > probably should be as well.
> >
> 
> Yes.
> I can send this one after Jouni patch will be merged.

Well I don't think he even sent it yet, so you could just send this one
with const?

johannes

