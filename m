Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59928 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755795Ab1KBRvH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Nov 2011 13:51:07 -0400
Subject: Re: [wireless-next PATCH 1/5] mac80211: Support forcing station to
 disable 11n.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4EB17103.70506@candelatech.com>
References: <1319778680-11405-1-git-send-email-greearb@candelatech.com>
	 (sfid-20111028_071135_777672_88A08497) <1319789318.3914.10.camel@jlt3.sipsolutions.net>
	 <4EAAFAA7.8090403@candelatech.com>
	 (sfid-20111028_205543_472872_4928ADE0) <1320220415.3950.1.camel@jlt3.sipsolutions.net>
	 <4EB17103.70506@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Nov 2011 18:51:03 +0100
Message-ID: <1320256263.7846.3.camel@jlt3.sipsolutions.net> (sfid-20111102_185112_125896_4098A33D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-11-02 at 09:34 -0700, Ben Greear wrote:

> > You misunderstood -- I said fullmac drivers, not differences between
> > ath9k, iwlwifi etc. Other cfg80211 drivers, not other mac80211 drivers.
> 
> Can you at least point me to some existing code that does a similar
> check?  I have no idea of what a fullmac driver even does.  I can test
> and eventually somewhat understand the paths for ath9k, but I have no
> ability to test fullmac (as far as I know).

Well ideally you have two patches -- one for cfg80211, and one for
mac80211. Then you can test the cfg80211 one w/o mac80211 patches, so it
behaves as though it didn't support it, and with the mac80211 patch it
sets the flag to support it. Just think about drivers like ath6kl.

johannes

