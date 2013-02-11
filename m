Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43007 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853Ab3BKLre (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 06:47:34 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U4rrA-0000df-9N
	for linux-wireless@vger.kernel.org; Mon, 11 Feb 2013 12:47:32 +0100
Message-ID: <1360583249.8738.16.camel@jlt4.sipsolutions.net> (sfid-20130211_124738_428386_FF1D6AD7)
Subject: Re: [PATCH] mac80211: fix chandef tracing bug
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 11 Feb 2013 12:47:29 +0100
In-Reply-To: <1360355449-20662-1-git-send-email-johannes@sipsolutions.net> (sfid-20130208_213058_453074_4BAECA0D)
References: <1360355449-20662-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130208_213058_453074_4BAECA0D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-08 at 21:30 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The chandef tracing writes center_freq1 twice, so
> that it is always 0 (no driver supports 80+80 yet)
> and leaves center_freq2 unset. Fix this mistake.

Applied.

johannes

