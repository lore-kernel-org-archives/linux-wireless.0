Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43893 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab3ABKwi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 05:52:38 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TqLw5-0004GJ-0F
	for linux-wireless@vger.kernel.org; Wed, 02 Jan 2013 11:52:37 +0100
Message-ID: <1357123983.9839.5.camel@jlt4.sipsolutions.net> (sfid-20130102_115240_360731_5614DE3D)
Subject: Re: [PATCH] mac80211: unset peer's HT 40 MHz support if not usable
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Wed, 02 Jan 2013 11:53:03 +0100
In-Reply-To: <1356703440-29267-1-git-send-email-johannes@sipsolutions.net> (sfid-20121228_150406_525116_53685D17)
References: <1356703440-29267-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121228_150406_525116_53685D17)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-12-28 at 15:04 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> When an interface is configured to a 20 MHz channel
> and the device as well as the peer are 40 MHz capable
> the HT capabilities of the peer are not restricted to
> 20 MHz, even though they're supposed to be restricted
> to the currently possible capabilities.
> 
> Unset the 40 MHz HT capability bits in this case.

Applied.

johannes

