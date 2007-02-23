Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:34641 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751841AbXBWVFM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Feb 2007 16:05:12 -0500
Message-ID: <45DF5635.5080905@linux.intel.com>
Date: Fri, 23 Feb 2007 13:01:41 -0800
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] d80211: create net/wireless/Kconfig and make nl80211  optional
References: <45DF518B.5060809@linux.intel.com> <1172263955.3870.85.camel@johannes.berg>
In-Reply-To: <1172263955.3870.85.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Fri, 2007-02-23 at 12:41 -0800, James Ketrenos wrote:
>> Move the wireless Kconfig options into their own wireless/Kconfig and
>> add a CONFIG_CFG80211_NL80211 configuration option to allow nl80211
>> support to be optionally included (default =y)
> 
> I think this one is missing the changes in net/Kconfig.
> 
> And I should have looked closer before, sorry.
> 
> +config CFG80211
> +        tristate "Improved wireless configuration API"
> +        select WIRELESS_EXT
> 
> Why is that select WIRELESS_EXT? CFG80211 doesn't need that, d80211 does
> and correctly selects it.

Confusion mostly...

I've removed it.

James
