Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60836 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755637Ab3ARUzu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2013 15:55:50 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TwIyb-0003lZ-P8
	for linux-wireless@vger.kernel.org; Fri, 18 Jan 2013 21:55:49 +0100
Message-ID: <1358542575.7922.9.camel@jlt4.sipsolutions.net> (sfid-20130118_215600_069855_32DF91F9)
Subject: Re: [PATCH] mac80211: allow drivers to access IPv6 information
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Fri, 18 Jan 2013 21:56:15 +0100
In-Reply-To: <1358379546-13811-1-git-send-email-johannes@sipsolutions.net> (sfid-20130117_003848_008666_573657E9)
References: <1358379546-13811-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130117_003848_008666_573657E9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-01-17 at 00:39 +0100, Johannes Berg wrote:
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

Applied.

johannes

