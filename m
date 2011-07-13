Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:9960 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103Ab1GMTXu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 15:23:50 -0400
Subject: Re: [FYI v2] iwlagn: implement WoWLAN
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1310580509.3873.14.camel@jlt3.sipsolutions.net>
References: <1310477822.3884.4.camel@jlt3.sipsolutions.net>
	 (sfid-20110712_153713_712619_C5FA4BCB)  <1310580509.3873.14.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Jul 2011 11:48:59 -0700
Message-ID: <1310582939.5579.7.camel@wwguy-huron> (sfid-20110713_212354_439970_C5B610C2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-07-13 at 11:08 -0700, Johannes Berg wrote:
> That first version was pretty borked ... I got confused about how the
> TKIP P1K works. It worked for WPA1 and WPA2/CCMP, but not WPA2/TKIP
> since then no unicast packets would have been received already that
> would be causing the P1K to be cached in the driver ... that part of the
> driver is really messed up...
> 
> 
> 
> iwlagn: implement WoWLAN
> 
ok, I will wait until you tell me it is stable enough for merge.

Thanks
Wey

