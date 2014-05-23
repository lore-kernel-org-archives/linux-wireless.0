Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:44382 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751795AbaEWNcB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 09:32:01 -0400
Message-ID: <1400851911.25946.42.camel@dubbel> (sfid-20140523_153206_022190_D3FD2DCB)
From: Luca Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: michal.kazior@tieto.com, linux-wireless@vger.kernel.org
Date: Fri, 23 May 2014 16:31:51 +0300
In-Reply-To: <1400851684.4358.41.camel@jlt4.sipsolutions.net>
References: <1400838772.4358.22.camel@jlt4.sipsolutions.net>
	 <1400844793-18069-1-git-send-email-luca@coelho.fi>
	 <1400844793-18069-2-git-send-email-luca@coelho.fi>
	 <1400851684.4358.41.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 2/2] mac80211: use switch_vif_chanctx to change a
 running chanctx
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-05-23 at 15:28 +0200, Johannes Berg wrote:
> On Fri, 2014-05-23 at 14:33 +0300, Luca Coelho wrote:
> > From: Luciano Coelho <luciano.coelho@intel.com>
> > 
> > Instead of hammering a new channel into the running context, make use
> > of the new switch_vif_chanctx to let the driver decide how to perform
> > the switch.
> > 
> > Additionally, remove the IEEE80211_HW_CHANGE_RUNNING_CHANCTX flag,
> > since we never change a running context directly anymore.
> 
> This seems totally reasonable to me, but I'll wait to see what Michal
> does :)

Yeah, I think so too, but if he specifically add us not to do this, it's
probably because he would have trouble rebasing or something. :)

--
Luca.

