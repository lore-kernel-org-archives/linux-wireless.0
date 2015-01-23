Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35452 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754765AbbAWJp1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 04:45:27 -0500
Message-ID: <1422006324.2728.13.camel@sipsolutions.net> (sfid-20150123_104531_276904_4A686CFE)
Subject: Re: [PATCH] mac80211: tell drivers the user TX power restriction
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Avri Altman <avri.altman@intel.com>
Date: Fri, 23 Jan 2015 10:45:24 +0100
In-Reply-To: <1421784945-7815-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1421784945-7815-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-01-20 at 22:15 +0200, Emmanuel Grumbach wrote:
> From: Avri Altman <avri.altman@intel.com>
> 
> When a tx power restriction is set, mac80211 protects its downstream
> stack by taking min(user, regulatory, 11h ap). However, we should allow
> drivers to use that value as it is - on their own risk.
> This might come handy, when tx power is set per phy. As mac80211 has
> only a concept of "per-vif" tx power, it iterates over the active vifs,
> and sets their tx power limit accordingly. Allowing this value to
> proliferate downstream unchanged, the driver might use this legacy
> api differently, e.g. to set tx power for the whole device.

This patch doesn't apply because I applied another patch (that was sent
many times well before this one.)

Please rework this patch on top of the current mac80211-next tree.

johannes

