Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43014 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab3BKLts (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 06:49:48 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U4rtL-0000hh-CZ
	for linux-wireless@vger.kernel.org; Mon, 11 Feb 2013 12:49:47 +0100
Message-ID: <1360583385.8738.21.camel@jlt4.sipsolutions.net> (sfid-20130211_124951_141372_E9597369)
Subject: Re: [PATCH] cfg80211: move TSF into IEs
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 11 Feb 2013 12:49:45 +0100
In-Reply-To: <1360079886-25168-1-git-send-email-johannes@sipsolutions.net> (sfid-20130205_165746_901093_2ED9F28C)
References: <1360079886-25168-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130205_165746_901093_2ED9F28C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-02-05 at 16:58 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> While technically the TSF isn't an IE, it can be
> necessary to distinguish between the TSF from a
> beacon and a probe response, in particular in
> order to know the next DTIM TBTT, as not all APs
> are spec compliant wrt. TSF==0 being a DTIM TBTT
> and thus the DTIM count needs to be taken into
> account as well.
> 
> To allow this, move the TSF into the IE struct
> so it can be known whence it came.

Applied.

johannes

