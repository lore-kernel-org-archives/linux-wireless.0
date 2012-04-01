Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:44839 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab2DAV0F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Apr 2012 17:26:05 -0400
Date: Sun, 01 Apr 2012 17:24:52 -0400 (EDT)
Message-Id: <20120401.172452.1589857453193260701.davem@davemloft.net> (sfid-20120401_232608_368442_07AAC331)
To: sgruszka@redhat.com
Cc: linux@dominikbrodowski.net, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Subject: Re: 3945ABG fails to connect (3.4-rc1)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120401165230.GA2399@redhat.com>
References: <20120401080419.GA5207@comet.dominikbrodowski.net>
	<20120401165230.GA2399@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <sgruszka@redhat.com>
Date: Sun, 1 Apr 2012 18:52:31 +0200

> On Sun, Apr 01, 2012 at 10:04:19AM +0200, Dominik Brodowski wrote:
>> Somewhere in between 3.3.0 and 3.4-rc1 my notebook fails to connect to my
>> local AP:
>> 
>> 02:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG [Golan] Network Connection (rev 02)
>> 
>> Snippets from dmesg:
> [snip]
>> [   59.605953] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
>> [   69.607344] wlan0: disassociating from $INSERT_MAC_HERE by local choice (reason=3)
>> [   69.609931] cfg80211: Calling CRDA to update world regulatory domain
>> [   69.612438] wlan0: deauthenticating from $INSERT_MAC_HERE by local choice (reason=3)
> Most likely this is fixed by: 
> http://marc.info/?l=linux-wireless&m=133180823427374&w=2
> 
> Plese test, thanks.

John, please make sure this gets to me after proper testing.

Thanks.
