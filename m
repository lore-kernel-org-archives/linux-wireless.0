Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45499 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932780Ab2F1K2o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 06:28:44 -0400
Message-ID: <1340879319.4491.38.camel@jlt3.sipsolutions.net> (sfid-20120628_122847_717329_4A0EC211)
Subject: Re: [PATCH] respect channels in iface combinations
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 28 Jun 2012 12:28:39 +0200
In-Reply-To: <1340878025-2695-1-git-send-email-michal.kazior@tieto.com>
References: <1340878025-2695-1-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-28 at 12:06 +0200, Michal Kazior wrote:
> Hi,
> 
> The patchset introduces channel tracking per interface which is needed
> to start enforcing num_different_channels in interface combinations.
> Changes to monitor mode behaviour is also required for sane channel
> accounting (considering how mac80211 handles monitor interfaces).
> 
> This prepares cfg80211 for multi-channel operation.

This didn't apply cleanly on mac80211-next due to preset_chan in
net/wireless/cfg80211.h. I think it's just context, but if you developed
this without the start_ap series I wonder how stop_ap makes much sense?

I'm a bit confused now?

johannes

