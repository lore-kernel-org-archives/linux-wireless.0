Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3448 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbZDEOgm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Apr 2009 10:36:42 -0400
Date: Sun, 5 Apr 2009 10:33:57 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: kalle.valo@nokia.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/6] wl12xx: update to 2.6.29 mac80211 hw scan API
Message-ID: <20090405143357.GA21913@hash.localnet> (sfid-20090405_163645_961847_2A633FDF)
References: <1238897428-19639-1-git-send-email-me@bobcopeland.com> <1238897428-19639-2-git-send-email-me@bobcopeland.com> <1238921906.3782.5.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1238921906.3782.5.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Apr 05, 2009 at 10:58:26AM +0200, Johannes Berg wrote:
> This will work for mac80211, but only by accident, and will not allow
> userspace to request directed scans -- you need to add
> 	hw->wiphy->max_scan_ssids = 1;

Thanks for the catch, I added this to my local copy.  Also, there needs
to be a patch that sets wiphy->interface_modes.

> somewhere. Supporting scan IEs would also be good, if possible.

Looks doable with some minor surgery.

-- 
Bob Copeland %% www.bobcopeland.com

