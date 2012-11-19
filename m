Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plout10-01.prod.sin2.secureserver.net ([182.50.145.4]:50837
	"HELO sg2plout10-01.prod.sin2.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753229Ab2KSQ2e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 11:28:34 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20650.24089.432204.301208@gargle.gargle.HOWL> (sfid-20121119_172837_579299_737AF98B)
Date: Mon, 19 Nov 2012 21:58:09 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] mac80211: fix channel context warning on suspend
In-Reply-To: <1353342211-21473-1-git-send-email-johannes@sipsolutions.net>
References: <1353342211-21473-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> If suspending with an idle interface that isn't
> actually operating, the channel context warning
> in ieee80211_vif_release_channel() triggers. Fix
> this by modifying the warning, it should only be
> warning if we're not suspending and get here.
> 
> Reported-by: Sujith Manoharan <sujith@msujith.org>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Thanks !

Tested-by: Sujith Manoharan <sujith@msujith.org>

Sujith
