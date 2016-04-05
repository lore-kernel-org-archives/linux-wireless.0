Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53338 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756749AbcDEJIK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 05:08:10 -0400
Message-ID: <1459847284.18188.19.camel@sipsolutions.net> (sfid-20160405_110813_719169_FAB582BD)
Subject: Re: [PATCH] mac80211:  Ensure no limits on station rhashtable.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com, linux-wireless@vger.kernel.org
Date: Tue, 05 Apr 2016 11:08:04 +0200
In-Reply-To: <1459545211-11517-1-git-send-email-greearb@candelatech.com>
References: <1459545211-11517-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-04-01 at 14:13 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> By default, the rhashtable logic will fail to insert
> objects if the key-chains are too long and un-balanced.
> 
> In the degenerate case where mac80211 is creating many
> station vdevs connected to the same peer, this case can
> be hit.
> 
> So, set insecure_elasticity to true to allow chains to grow
> as long as needed.
> 
Applied.

johannes
