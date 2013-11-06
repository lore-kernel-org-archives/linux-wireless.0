Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43182 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086Ab3KFLAo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 06:00:44 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Ve0qp-0002IV-Bk
	for linux-wireless@vger.kernel.org; Wed, 06 Nov 2013 12:00:43 +0100
Message-ID: <1383735641.14307.32.camel@jlt4.sipsolutions.net> (sfid-20131106_120046_725644_A258F804)
Subject: Re: [PATCH] cfg80211: don't allow drivers to unset
 NL80211_FEATURE_SCAN_FLUSH
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Wed, 06 Nov 2013 12:00:41 +0100
In-Reply-To: <1382969330-25707-1-git-send-email-johannes@sipsolutions.net> (sfid-20131028_150857_467838_FE7E36B9)
References: <1382969330-25707-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20131028_150857_467838_FE7E36B9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-10-28 at 15:08 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> As the flag is entirely implemented in cfg80211, it should
> have been a global feature flag (which I believe didn't
> exist at the time). However, there's no reason to allow
> drivers to unset the flag, so don't allow it and remove
> the validation of NL80211_SCAN_FLAG_FLUSH.

Applied.

johannes

