Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54297 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891Ab1ASOfK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 09:35:10 -0500
Subject: Re: [RFC] mac80211: support for IEEE80211N in IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Simon <alexander.simon@saxnet.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <201101191438.01161.alexander.simon@saxnet.de>
References: <201101191438.01161.alexander.simon@saxnet.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Jan 2011 15:35:08 +0100
Message-ID: <1295447708.4685.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-01-19 at 14:38 +0100, Alexander Simon wrote:
> Hey list,
> 
> finally i got my (in ath9ks list announced) patch for HT rates in ad-hoc 
> networks ready that has been requested quite often.
> I took the initial patches from Benoît Papillault and worked on them.

Didn't he have versions that refactored more, like the IE building?
That'd be good in any case.

Can you split this up into a few patches and repost inline (not
attached) so we can review it more easily?

johannes

