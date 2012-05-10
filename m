Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34491 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756693Ab2EJHbn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 03:31:43 -0400
Message-ID: <1336635100.4334.8.camel@jlt3.sipsolutions.net> (sfid-20120510_093147_566111_7292B9E4)
Subject: Re: [PATCH 7/7] mac80211: move oper_channel to sdata
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 10 May 2012 09:31:40 +0200
In-Reply-To: <1336632282-2278-8-git-send-email-michal.kazior@tieto.com>
References: <1336632282-2278-1-git-send-email-michal.kazior@tieto.com>
	 <1336632282-2278-8-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-05-10 at 08:44 +0200, Michal Kazior wrote:

> +	/* cfg80211 arbitrates multi-channel */
> +	if (local->hw.wiphy->flags & WIPHY_FLAG_ENFORCE_COMBINATIONS)
> +		return true;

This no longer exists, but that's just arbitrating
multi-virtual-interface, not necessarily multi-channel, I think?

I need more time to look over this, in particular wrt. this arbitration.

johannes

