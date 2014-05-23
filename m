Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:44294 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752069AbaEWLf5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 07:35:57 -0400
Message-ID: <1400844948.25946.39.camel@dubbel> (sfid-20140523_133601_834500_3F2C95E5)
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: michal.kazior@tieto.com, linux-wireless@vger.kernel.org
Date: Fri, 23 May 2014 14:35:48 +0300
In-Reply-To: <1400844793-18069-2-git-send-email-luca@coelho.fi>
References: <1400838772.4358.22.camel@jlt4.sipsolutions.net>
	 <1400844793-18069-1-git-send-email-luca@coelho.fi>
	 <1400844793-18069-2-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 2/2] mac80211: use switch_vif_chanctx to change a
 running chanctx
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
> 
> Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
> ---

This is optional, you don't have to apply it if you're going to take
Michal's patches (since they will undo this change anyway), as we
discussed on IRC.

So, this is mostly just for the record.

--
Luca.

