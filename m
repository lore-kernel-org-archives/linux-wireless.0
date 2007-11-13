Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:40579 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758586AbXKMRVy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2007 12:21:54 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2011384wah
        for <linux-wireless@vger.kernel.org>; Tue, 13 Nov 2007 09:21:54 -0800 (PST)
Subject: Re: [PATCH 4/4] o80211s: (zd1211rw-mac80211) support for mesh
	interface
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1194959673.9116.46.camel@johannes.berg>
References: <473516f2.15528c0a.7196.3372@mx.google.com>
	 (sfid-20071110_022703_924708_89D9D43C)  <1194689934.7258.66.camel@johannes.berg>
	 <1194911599.6980.107.camel@localhost>
	 (sfid-20071112_235326_369001_A52ADA69)  <1194959673.9116.46.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 13 Nov 2007 09:21:53 -0800
Message-Id: <1194974513.6057.17.camel@localhost> (sfid-20071113_172212_443829_CA6721EB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-11-13 at 14:14 +0100, Johannes Berg wrote: 
> > > Does that mean you're hardcoding the beacon interval here while before
> > > you confused me how we should handle that setting in userspace? :)
> > 
> > I am not sure what are you referring to... anyway, by now I think it's
> > fine to hard code the beacon interval, but in mac80211 instead of the
> > driver adding a beacon_int field to ieee80211_if_conf.
> 
> Well that | 100 looks like it'd be a beacon interval in the lower N bits
> of the value that's set there.

Yes, it is, and I agree it should be moved up to mac80211. What I meant
is that I do not remember saying anything about how to handle that
setting in user space (and thus I don't know when I confused you).

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


