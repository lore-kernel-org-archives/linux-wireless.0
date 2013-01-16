Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37771 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab3APOTJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 09:19:09 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TvTpc-0000TY-CG
	for linux-wireless@vger.kernel.org; Wed, 16 Jan 2013 15:19:08 +0100
Message-ID: <1358345974.22862.14.camel@jlt4.sipsolutions.net> (sfid-20130116_151913_912971_9BEC3F94)
Subject: Re: [RFC] mac80211: allow drivers to access IPv6 information
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Wed, 16 Jan 2013 15:19:34 +0100
In-Reply-To: <1358173010-16985-1-git-send-email-johannes@sipsolutions.net> (sfid-20130114_151631_494051_DB12C072)
References: <1358173010-16985-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130114_151631_494051_DB12C072)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-01-14 at 15:16 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> To be able to implement NS response offloading (in
> regular operation or while in WoWLAN) drivers need
> to know the IPv6 addresses assigned to interfaces.
> Implement an IPv6 notifier in mac80211 to call the
> driver when addresses change.
> 
> Unlike for IPv4, implement it as a callback rather
> than as a list in the BSS configuration, that is
> more flexible.

Applied the fixed version.

johannes

