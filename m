Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:42962 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758370Ab3BFTxZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 14:53:25 -0500
Date: Wed, 06 Feb 2013 14:53:20 -0500 (EST)
Message-Id: <20130206.145320.721522259467415518.davem@davemloft.net> (sfid-20130206_205350_644304_D57786DF)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2013-02-06
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130206193423.GI2148@tuxdriver.com>
References: <20130206193423.GI2148@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 6 Feb 2013 14:34:23 -0500

> Please consider this pull request for the 3.8 stream...
> 
> Included is a bluetooth pull.  Gustavo says:
> 
> "Two simple fixes for 3.8. One of the patches fixes a situation
> where the connection wasn't terminated if a timeout ocurrs for LE
> an SCO connections.  The other fixes prevent NULL dereference in the
> SMP code, it is a security fix as well."
> 
> Along with those...
> 
> Hauke Mehrtens provides a couple of ssb and bcma bus fixes that
> prevent oopses when unloading those modules.
> 
> Larry Finger provides and rtlwifi fix to avoid a "scheduling while
> atomic" bug.
> 
> Last but certainly not least, Arend van Spriel bring a brcmsmac fix that
> reworks the mac80211 .flush() callback in order to avoid the dreaded
> brcms_c_wait_for_tx_completion warnings.  This one looks a little
> large, but I think it is safe and isolated to brcmsmac in any case.
> 
> Please let me know if there are problems!

Pulled, even though the comments weren't styled correctly
in the bluetooth fixes.  Please fix that when this stuff
propagates into net-next, thanks.
