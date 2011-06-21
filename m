Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54736 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756768Ab1FUQCh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 12:02:37 -0400
Subject: Re: [RFC v3 1/3] mac80211: add some helper functions
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Simon <alexander.simon@saxnet.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1308671129.2656.4.camel@alex-2> (sfid-20110621_174753_258660_B2E3ED7C)
References: <1308671129.2656.4.camel@alex-2>
	 (sfid-20110621_174753_258660_B2E3ED7C)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Jun 2011 18:02:33 +0200
Message-ID: <1308672153.4276.9.camel@jlt3.sipsolutions.net> (sfid-20110621_180240_721946_D4747411)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-06-21 at 17:45 +0200, Alexander Simon wrote:
> Add helper functions cfg80211_get_bss_ht, ieee80211_ie_build_ht_cap
> and ieee80211_ie_build_ht_info.
> These are needed for my IBSS HT patch but are also used to clean up some
> multiple code.

I'll review in the next couple of days, but we have a holiday on
Thursday and I'll take Friday off so it might be next week.

johannes

