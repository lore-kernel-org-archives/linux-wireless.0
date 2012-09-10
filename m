Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35565 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347Ab2IJJ2b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 05:28:31 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TB0I9-0001VM-R6
	for linux-wireless@vger.kernel.org; Mon, 10 Sep 2012 11:28:29 +0200
Message-ID: <1347269347.4272.0.camel@jlt4.sipsolutions.net> (sfid-20120910_112836_955903_D5F81A48)
Subject: Re: [PATCH] mac80211: add key flag for management keys
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 10 Sep 2012 11:29:07 +0200
In-Reply-To: <1347038794-29039-1-git-send-email-johannes@sipsolutions.net> (sfid-20120907_192610_156310_D18221CA)
References: <1347038794-29039-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120907_192610_156310_D18221CA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-09-07 at 19:26 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Mark keys that might be used to receive management
> frames so drivers can fall back on software crypto
> for them if they don't support hardware offload.
> As the new flag is only set correctly for RX keys
> and the existing IEEE80211_KEY_FLAG_SW_MGMT flag
> can only affect TX, also rename the latter to
> IEEE80211_KEY_FLAG_SW_MGMT_TX.

Applied.

johannes

