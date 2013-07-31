Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51942 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab3GaTR3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 15:17:29 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1V4btn-0002F4-W7
	for linux-wireless@vger.kernel.org; Wed, 31 Jul 2013 21:17:28 +0200
Message-ID: <1375298245.8289.19.camel@jlt4.sipsolutions.net> (sfid-20130731_211731_073334_1602C94D)
Subject: Re: [PATCH 3.11] cfg80211: fix P2P GO interface teardown
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Wed, 31 Jul 2013 21:17:25 +0200
In-Reply-To: <1375297347-1380-1-git-send-email-johannes@sipsolutions.net> (sfid-20130731_210237_569724_A4F81D1E)
References: <1375297347-1380-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130731_210237_569724_A4F81D1E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-07-31 at 21:02 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> When a P2P GO interface goes down, cfg80211 doesn't properly
> tear it down, leading to warnings later. Add the GO interface
> type to the enumeration to tear it down like AP interfaces.
> Otherwise, we leave it pending and mac80211's state can get
> very confused, leading to warnings later.

Applied

(it's obvious and we've tested it for a while)

johannes

