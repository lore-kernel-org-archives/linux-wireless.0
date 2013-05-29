Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59872 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933908Ab3E2HB0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 May 2013 03:01:26 -0400
Message-ID: <1369810880.8414.0.camel@jlt4.sipsolutions.net> (sfid-20130529_090129_582208_50EAC73B)
Subject: Re: pull-request: iwlwifi-next 2013-05-27
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 29 May 2013 09:01:20 +0200
In-Reply-To: <1369658029.14740.7.camel@jlt4.sipsolutions.net> (sfid-20130527_143407_283994_588E3186)
References: <1369658029.14740.7.camel@jlt4.sipsolutions.net>
	 (sfid-20130527_143407_283994_588E3186)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-05-27 at 14:33 +0200, Johannes Berg wrote:
> John,
> 
> I have accumulated a bunch of new things in iwlwifi-next. Unfortunately,
> to resolve a (semantic) conflict, I had to merge iwlwifi, which pulled
> in some ath9k/mwifiex changes we well since you didn't merge wireless
> into wireless-next at any point. If you want to handle this differently
> let me know. The shortlog below also looks inflated because of that,
> I've also pasted the 'real' one below the pull request.
> 
> The 'big features' I have are powersave related, including beacon
> filtering and connection monitor (which I have been sitting on for a
> while because it required a mac80211 patch) and thermal throttling/CT
> kill. The rest is mostly cleanups and small(ish) improvements.

Hm, withdrawn, we found a bunch of issues in the CT kill code. I'll
combine in a few fixes and then resend.

johannes

