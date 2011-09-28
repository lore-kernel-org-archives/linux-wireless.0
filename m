Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35635 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288Ab1I1Nsw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Sep 2011 09:48:52 -0400
Subject: Re: [PATCH 3/3] mac80211: pass vif param to conf_tx() callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1316970415-23239-3-git-send-email-eliad@wizery.com> (sfid-20110925_190724_392119_D7C5583F)
References: <1316970415-23239-1-git-send-email-eliad@wizery.com>
	 <1316970415-23239-3-git-send-email-eliad@wizery.com>
	 (sfid-20110925_190724_392119_D7C5583F)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Sep 2011 15:48:28 +0200
Message-ID: <1317217708.3986.17.camel@jlt3.sipsolutions.net> (sfid-20110928_154856_280002_4A14F93D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-09-25 at 20:06 +0300, Eliad Peller wrote:
> tx params should be configured per interface.
> Add ieee80211_vif param to the conf_tx callback,
> and update all the drivers that use this callback.

I see patches 1 and 2 in the tree, but not this. I suspect the reason is
that it was actually incomplete, not updating for example iwlwifi
because there the function is defined in another file and the spatch
failed?

johannes

