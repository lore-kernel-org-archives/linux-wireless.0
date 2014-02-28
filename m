Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33182 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaB1TAU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 14:00:20 -0500
Date: Fri, 28 Feb 2014 13:58:41 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Zhao, Gang" <gamerh2o@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 7/7] ieee80211: remove function
 ieee80211_{dsss_chan_to_freq, freq_to_dsss_chan}
Message-ID: <20140228185840.GI30876@tuxdriver.com> (sfid-20140228_200024_278186_3F981E63)
References: <cover.1392728354.git.gamerh2o@gmail.com>
 <cover.1392728354.git.gamerh2o@gmail.com>
 <c9305f68668f20186c1b2a8f8f3f6dac3d23b5db.1392728354.git.gamerh2o@gmail.com>
 <878ut75352.fsf@will.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <878ut75352.fsf@will.lan>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 19, 2014 at 08:59:05AM +0800, Zhao, Gang wrote:
> On Tue, 2014-02-18 at 21:36:03 +0800, Zhao, Gang wrote:
> > Function ieee80211_{dsss_chan_to_freq, freq_to_dsss_chan} have been
> > replaced with ieee80211_{channel_to_frequency, frequency_to_channel}.
> >
> > There should be no users of the two functions now. So remove them.
> >
> > Cc: Johannes Berg <johannes.berg@intel.com>
> > Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
> > ---
> 
> Since staging driver wlan-ng uses function ieee80211_dsss_chan_to_freq,
> This patch "ieee80211: remove function ieee80211_{dsss_chan_to_freq,
> freq_to_dsss_chan}" should be applied later, when that staging-next
> patch "staging: wlan-ng: replace function ieee80211_dsss_chan_to_freq()"
> appear on wireless-next.

I'm not particularly concerned about breaking drivers in staging...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
