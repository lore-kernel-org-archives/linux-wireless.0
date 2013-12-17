Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:46624 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab3LQTzj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 14:55:39 -0500
Message-ID: <1387310134.4749.17.camel@jlt4.sipsolutions.net> (sfid-20131217_205543_329408_4A2608C5)
Subject: Re: [PATCH 3.13] ath9k: disable radar detection support
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 17 Dec 2013 20:55:34 +0100
In-Reply-To: <201312171809.09180.sw@simonwunderlich.de>
References: <1387276187-16063-1-git-send-email-johannes@sipsolutions.net>
	 <201312171809.09180.sw@simonwunderlich.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-12-17 at 18:09 +0100, Simon Wunderlich wrote:

> as discussed already on IRC, what we consider "broken" is: the lockdep issue 
> which Kalle (and maybe others?) reported for hwsim, but that does not affect 
> ath9k. Probably a hwsim problem only.

It does affect ath9k, but the issue can't actually happen in practice
due to other considerations that lockdep can't really prove. It's still
ugly and we should fix it.

> For the other issue for which Marek Puzyniak sent a patch ("cfg80211: fix dfs 
> channel state after stopping AP"), I don't think this is a bug which should be 
> fixed, but intential to keep the channel AVAILABLE after leaving the AP on a 
> channel. Let's discuss this in the thread for this patch ...

Fair enough.

Let's drop this.

johannes


