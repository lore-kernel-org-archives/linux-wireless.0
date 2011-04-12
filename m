Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57036 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab1DLLQu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 07:16:50 -0400
Subject: Re: [PATCH 3/4] mac80211: Add function to build HT caps
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Simon <alexander.simon@saxnet.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <loom.20110412T130449-831@post.gmane.org>
References: <1302604964.2139.5.camel@alex-2>
	 <loom.20110412T130449-831@post.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Apr 2011 13:16:48 +0200
Message-ID: <1302607008.3639.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-04-12 at 11:06 +0000, Alexander Simon wrote:

> +u8 *ieee80211_ie_build_ht_cap(u8 *pos, struct ieee80211_supported_band *sband,
> +                              u16 cap)

It makes no sense to pass cap as an argument since it's taken from the
sband.

johannes

