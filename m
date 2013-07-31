Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51943 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760268Ab3GaTRs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 15:17:48 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1V4bu8-0002FT-19
	for linux-wireless@vger.kernel.org; Wed, 31 Jul 2013 21:17:48 +0200
Message-ID: <1375298265.8289.20.camel@jlt4.sipsolutions.net> (sfid-20130731_211801_634059_B7100962)
Subject: Re: [PATCH 3.11] mac80211: don't wait for TX status forever
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Wed, 31 Jul 2013 21:17:45 +0200
In-Reply-To: <1375258961-26321-1-git-send-email-johannes@sipsolutions.net> (sfid-20130731_102255_451028_6D22D481)
References: <1375258961-26321-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130731_102255_451028_6D22D481)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-07-31 at 10:22 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> TX status notification can get lost, or the frames could
> get stuck on the queue, so don't wait for the callback
> from the driver forever and instead time out after half
> a second.

Applied.

johannes

