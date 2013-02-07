Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56528 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756369Ab3BGUCJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 15:02:09 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U3Xfc-0007z2-5x
	for linux-wireless@vger.kernel.org; Thu, 07 Feb 2013 21:02:08 +0100
Message-ID: <1360267353.8038.14.camel@jlt4.sipsolutions.net> (sfid-20130207_210212_861427_FC479581)
Subject: Re: [PATCH] mac80211: fix managed mode channel context use
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 07 Feb 2013 21:02:33 +0100
In-Reply-To: <1360266989-23582-1-git-send-email-johannes@sipsolutions.net> (sfid-20130207_205615_447278_08689902)
References: <1360266989-23582-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130207_205615_447278_08689902)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-02-07 at 20:56 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> My commit f2d9d270c15ae0139b54a7e7466d738327e97e03
> ("mac80211: support VHT association") introduced a
> very stupid bug: the loop to downgrade the channel
> width never attempted to actually use it again so
> it would downgrade all the way to 20_NOHT. Fix it.

Applied, of course (since it's even in the pull request already :) )

johannes

