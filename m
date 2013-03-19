Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:54918 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702Ab3CSScV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 14:32:21 -0400
Received: by mail-we0-f171.google.com with SMTP id r3so254854wey.30
        for <linux-wireless@vger.kernel.org>; Tue, 19 Mar 2013 11:32:20 -0700 (PDT)
Date: Tue, 19 Mar 2013 19:29:15 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [RFC 1/2] mac80211: Use a cfg80211_chan_def in
 ieee80211_hw_conf_chan
Message-ID: <20130319182915.GC26078@magnum.frso.rivierawaves.com> (sfid-20130319_193225_570857_CE59AC38)
References: <1363552234-6752-1-git-send-email-karl.beldan@gmail.com>
 <1363552234-6752-2-git-send-email-karl.beldan@gmail.com>
 <1363634710.8260.15.camel@jlt4.sipsolutions.net>
 <20130318213833.GA25758@gobelin>
 <1363717491.8336.1.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1363717491.8336.1.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 19, 2013 at 07:24:51PM +0100, Johannes Berg wrote:
> On Mon, 2013-03-18 at 22:38 +0100, Karl Beldan wrote:
> 
> > > However this already exists in cfg80211.h --
> > > cfg80211_chandef_identical().
> > > 
> > cfg80211_chandef_identical() will compare the whole chandef whatever the
> > channel width.
> 
> As it should, a chandef where the unused fields are random isn't even
> valid and will cause warnings left and right. That's a deliberate design
> choice to simplify usage.
> 
Yes, that's what I figured _afterwards_ (c.f todays emails) ;)
 
Karl
