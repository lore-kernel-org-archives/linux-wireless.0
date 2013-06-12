Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:60785 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756816Ab3FLWCD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jun 2013 18:02:03 -0400
Date: Wed, 12 Jun 2013 15:01:59 -0700 (PDT)
Message-Id: <20130612.150159.936180836505278347.davem@davemloft.net> (sfid-20130613_000213_106471_E0627815)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull request: wireless-next 2013-06-11
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130611190546.GE3196@tuxdriver.com>
References: <20130611190546.GE3196@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=euc-kr
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 11 Jun 2013 15:05:48 -0400

> This pull request is intended for the 3.11 stream...
> 
> One big highlight is the cw1200 driver the ST-E CW1100 & CW1200
> WLAN chipsets.  This one has been lingering for a while, lacking
> some review comments.  Once started getting pulled into linux-next,
> it got a bit more attention and a number of improvements were made
> over the initial cut.  No doubt there will be more changes ahead,
> but I think it is looking alright at this point.
> 
> Along with that, there is the usual flurry of updates to the mac80211
> core and the iwlwifi, mwifiex, ath9k, rt2x00, wil6210, and other
> drivers.  A few of the highlights are some rt2x00 refactoring/cleanup
> by Gabor Juhos, some rt2800 hardware support enhancements by Stanislaw
> Gruszka, some iwlwifi power management updates from Alexander Bondar,
> some enhanced bcma SPROM support from Rafa©© Mi©©ecki, and a variety
> of other things here and there.

Pulled, thanks John.
