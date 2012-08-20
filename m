Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36381 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab2HTLyq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2012 07:54:46 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1T3QZB-0005WD-DV
	for linux-wireless@vger.kernel.org; Mon, 20 Aug 2012 13:54:45 +0200
Message-ID: <1345463683.4459.19.camel@jlt3.sipsolutions.net> (sfid-20120820_135449_930572_7C53552A)
Subject: Re: [PATCH] mac80211: reset station MLME flags upon new association
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 20 Aug 2012 13:54:43 +0200
In-Reply-To: <1343845319-22113-1-git-send-email-johannes@sipsolutions.net> (sfid-20120801_202208_640686_FADACD7B)
References: <1343845319-22113-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120801_202208_640686_FADACD7B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-08-01 at 20:21 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> When associating anew, the old station MLME flags should
> be cleared. The only exception is the 40 MHz disable
> flag as it might have been set while the channel was set
> in a previous authentication attempt so it needs to be
> kept intact.

Looks like I had already applied this...

johannes

