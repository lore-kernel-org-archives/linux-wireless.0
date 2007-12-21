Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4837 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920AbXLUO3u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Dec 2007 09:29:50 -0500
Date: Fri, 21 Dec 2007 09:15:57 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Andreas Schwab <schwab@suse.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH] mac80211: remove useless sdata variable
Message-ID: <20071221141557.GC19874@tuxdriver.com> (sfid-20071221_142953_564616_99C3F2D4)
References: <1198195385.16241.68.camel@johannes.berg> <je63ysp7ua.fsf@sykes.suse.de> <1198240471.16241.70.camel@johannes.berg> <je1w9gp5ll.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <je1w9gp5ll.fsf@sykes.suse.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 21, 2007 at 01:58:14PM +0100, Andreas Schwab wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> 
> >> Perhaps because it is used?
> >> 
> >> > --- everything.orig/net/mac80211/ieee80211_sta.c	2007-12-21 01:02:11.253160428 +0100
> >> > +++ everything/net/mac80211/ieee80211_sta.c	2007-12-21 01:02:32.113165907 +0100
> >> > @@ -458,12 +458,10 @@ static void ieee80211_set_associated(str
> >> >  		return;
> >> >  
> >> >  	if (assoc) {
> >> > -		struct ieee80211_sub_if_data *sdata;
> >
> > Too little context. There's another one in the surrounding scope that is
> > already initialised exactly the same.
> 
> Sorry, but I can't find it.  Was it added in an unmerged patch?

I think I'm with Andreas here...?

-- 
John W. Linville
linville@tuxdriver.com
