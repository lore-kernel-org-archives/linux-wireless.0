Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:57055 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab3BLVNT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 16:13:19 -0500
Date: Tue, 12 Feb 2013 16:13:17 -0500 (EST)
Message-Id: <20130212.161317.1315936101869036107.davem@davemloft.net> (sfid-20130212_221342_923389_C84A9A70)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2013-02-12
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130212160316.GA2086@tuxdriver.com>
References: <20130212160316.GA2086@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 12 Feb 2013 11:03:16 -0500

> Here is another handful of late-breaking fixes intended for the 3.8
> stream...  Hopefully the will still make it! :-)
> 
> There are three mac80211 fixes pulled from Johannes:
> 
> "Here are three fixes still for the 3.8 stream, the fix from Cong Ding
> for the bad sizeof (Stephen Hemminger had pointed it out before but I'd
> promptly forgotten), a mac80211 managed-mode channel context usage fix
> where a downgrade would never stop until reaching non-HT and a bug in
> the channel determination that could cause invalid channels like HT40+
> on channel 11 to be used."
> 
> Also included is a mwl8k fix that avoids an oops when using mwl8k
> devices that only support the 5 GHz band.
> 
> Please let me know if there are problems!

Pulled, thanks John.
