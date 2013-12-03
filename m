Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43880 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437Ab3LCPXl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 10:23:41 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Vnrp6-00019A-Cs
	for linux-wireless@vger.kernel.org; Tue, 03 Dec 2013 16:23:40 +0100
Message-ID: <1386084218.4393.36.camel@jlt4.sipsolutions.net> (sfid-20131203_162345_249835_FE666F16)
Subject: Re: [PATCH] nl80211: vendor command support
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Tue, 03 Dec 2013 16:23:38 +0100
In-Reply-To: <1384346267-4174-1-git-send-email-johannes@sipsolutions.net> (sfid-20131113_133756_475020_6AF572DF)
References: <1384346267-4174-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20131113_133756_475020_6AF572DF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-11-13 at 13:37 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Add support for vendor-specific commands to nl80211. This is
> intended to be used for really vendor-specific functionality
> that can't be implemented in a generic fashion for any reason.
> It's *NOT* intended to be used for any normal/generic feature
> or any optimisations that could be implemented across drivers.
> 
> Currently, only vendor commands (with replies) are supported,
> no dump operations or vendor-specific notifications.
> 
> Also add a function wdev_to_ieee80211_vif() to mac80211 which
> is needed for mac80211-based drivers wanting to implement any
> vendor commands.

Not sure why I forgot this -- applied now.

johannes

