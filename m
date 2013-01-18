Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60829 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209Ab3ARUxx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2013 15:53:53 -0500
Message-ID: <1358542457.7922.2.camel@jlt4.sipsolutions.net> (sfid-20130118_215405_296335_37BFA037)
Subject: Re: [PATCH] mac80211: remove ARP filter enable/disable logic
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com
Date: Fri, 18 Jan 2013 21:54:17 +0100
In-Reply-To: <1358369001-19722-1-git-send-email-johannes@sipsolutions.net> (sfid-20130116_214305_761725_51CBFC89)
References: <1358369001-19722-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130116_214305_761725_51CBFC89)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-01-16 at 21:43 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Depending on the driver, having ARP filtering for
> some addresses may be possible. Remove the logic
> that tracks whether ARP filter is enabled or not
> and give the driver the total number of addresses
> instead of the length of the list so it can make
> its own decision.

Applied.

johannes

