Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:36243 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064Ab3APUtm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 15:49:42 -0500
Message-ID: <1358369325.6252.9.camel@cumari.coelho.fi> (sfid-20130116_214947_049487_73257FAA)
Subject: Re: [PATCH] mac80211: remove ARP filter enable/disable logic
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
Date: Wed, 16 Jan 2013 22:48:45 +0200
In-Reply-To: <1358369001-19722-1-git-send-email-johannes@sipsolutions.net>
References: <1358369001-19722-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
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
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---

Looks good now.  Thanks! :)

Reviewed-by: Luciano Coelho <coelho@ti.com>

--
Luca.

