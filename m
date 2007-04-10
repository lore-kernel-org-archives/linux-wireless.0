Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3153 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753781AbXDJOBd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2007 10:01:33 -0400
Date: Tue, 10 Apr 2007 09:39:53 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Gallo Renato <renatogallo@katamail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: intel 3945 testing the drivers on slack
Message-ID: <20070410133953.GA14123@tuxdriver.com>
References: <1176187118.2201.8.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1176187118.2201.8.camel@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 10, 2007 at 08:38:38AM +0200, Gallo Renato wrote:

> on the dmesg and disconnects losing the wireless extentions I decided to
> try the new kernel 2.6.20.6 with the drivers
> iwlwifi-0.0.11/  iwlwifi-0.0.11.tgz  iwlwifi-ucode-2.14.1/
> iwlwifi-ucode-2.14.1.tgz  mac80211-6.0.0/  mac80211-6.0.0.tgz
> 
> 
> but got troubles compiling since after the patching phase it gives me 
> 
> CC      drivers/net/wireless/mac80211/iwlwifi/base.o
> drivers/net/wireless/mac80211/iwlwifi/base.c: In function
> `ipw_rate_scale_rate_init':
> drivers/net/wireless/mac80211/iwlwifi/base.c:11695: error: structure has
> no member named `num_curr_rates'
> drivers/net/wireless/mac80211/iwlwifi/base.c:11697: error: structure has
> no member named `curr_rates'

It sounds like there is a mismatch between the iwlwifi version and
mac80211 version you are using?  Dunno.

I'll leave it to the iwlwifi guys to answer more...

John
-- 
John W. Linville
linville@tuxdriver.com
