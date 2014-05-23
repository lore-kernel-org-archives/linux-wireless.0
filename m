Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48242 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511AbaEWN2T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 09:28:19 -0400
Message-ID: <1400851684.4358.41.camel@jlt4.sipsolutions.net> (sfid-20140523_152830_297880_56D4CFD5)
Subject: Re: [PATCH 2/2] mac80211: use switch_vif_chanctx to change a
 running chanctx
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: michal.kazior@tieto.com, linux-wireless@vger.kernel.org
Date: Fri, 23 May 2014 15:28:04 +0200
In-Reply-To: <1400844793-18069-2-git-send-email-luca@coelho.fi>
References: <1400838772.4358.22.camel@jlt4.sipsolutions.net>
	 <1400844793-18069-1-git-send-email-luca@coelho.fi>
	 <1400844793-18069-2-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-05-23 at 14:33 +0300, Luca Coelho wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
> 
> Instead of hammering a new channel into the running context, make use
> of the new switch_vif_chanctx to let the driver decide how to perform
> the switch.
> 
> Additionally, remove the IEEE80211_HW_CHANGE_RUNNING_CHANCTX flag,
> since we never change a running context directly anymore.

This seems totally reasonable to me, but I'll wait to see what Michal
does :)

johannes

