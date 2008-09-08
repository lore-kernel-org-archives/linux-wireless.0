Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:6448 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbYIHGpZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 02:45:25 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2 v4] cfg80211: Add new wireless regulatory infrastructure
Date: Mon, 8 Sep 2008 08:44:58 +0200
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"Johannes Berg" <johannes@sipsolutions.net>, linville@tuxdriver.com
References: <1220636669-8153-1-git-send-email-lrodriguez@atheros.com> <1220640389.11109.15.camel@johannes.berg> <43e72e890809051211r3db3ca12m671c9ed9615b9e1b@mail.gmail.com>
In-Reply-To: <43e72e890809051211r3db3ca12m671c9ed9615b9e1b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200809080844.59098.hs4233@mail.mn-solutions.de> (sfid-20080908_084529_568532_5C126507)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 05 September 2008 21:11:49 Luis R. Rodriguez wrote:
> >> +struct ieee80211_freq_range {
> >> +     u32 start_freq;
> >> +     u32 end_freq;
> >> +     u32 max_bandwidth;
> >
> > u32 seems excessive for the bandwidth, no?
>
> I think its fine, remember this is in KHz.

max_bandwitth_khz ???


> >>       u16 center_freq;
> >> +     u8 max_bandwidth;
> >
> > and here you're using u8 anyway :)
>
> and this is in MHz

max_bandwidth_mhz ???
