Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49971 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756026Ab1ISMzt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 08:55:49 -0400
Subject: Re: [PATCH v3 2/3] mac80211: Add HT helper functions
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Simon <an.alexsimon@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1501100748f4096d10848f6eec03f22e96e35b8e.1316297595.git.an.alexsimon@googlemail.com> (sfid-20110918_001535_468646_05ED40D3)
References: <35635039ce7d4a79dc62b19d51ccf0d5d4838112.1316297595.git.an.alexsimon@googlemail.com>
	 <1501100748f4096d10848f6eec03f22e96e35b8e.1316297595.git.an.alexsimon@googlemail.com>
	 (sfid-20110918_001535_468646_05ED40D3)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Sep 2011 14:55:47 +0200
Message-ID: <1316436947.5995.23.camel@jlt3.sipsolutions.net> (sfid-20110919_145554_754634_21A9D17E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-09-18 at 00:14 +0200, Alexander Simon wrote:
> Some refactoring for IBSS HT.
> 
> Move HT info and capability IEs building code into separate functions.
> 
> Add function to get the channel type from an HT info IE.

> +enum nl80211_channel_type
> +ieee80211_ht_info_to_channel_type(struct ieee80211_ht_info *ht_info);

Did I miss it, or do you not use that function any more?

johannes

