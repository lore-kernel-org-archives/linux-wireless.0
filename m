Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:19755 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756678Ab0GBQIp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jul 2010 12:08:45 -0400
Subject: Re: iwlwifi and 802.11s
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Iuri Diniz <iuridiniz@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTim89kFmpafv2UsmanpiysGw8W1nfKZGXPsjPpXZ@mail.gmail.com>
References: <AANLkTim89kFmpafv2UsmanpiysGw8W1nfKZGXPsjPpXZ@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 02 Jul 2010 09:08:02 -0700
Message-Id: <1278086882.2657.18.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Iuri,

Yes, it is possible to add "mesh" support to iwlwifi, but currently it
is not in our (Intel) schedule to enable/support this feature.

If you or anybody from community would like to implement and support
this feature, it is very welcome and we will consider the patches for
inclusion, but base on few requirements:

 * We assume the patches make "mesh" works since we are not testing the
mesh functions
 * The mesh feature should not break any of the normal WiFi operations
which we _do_ test for
 * Since we are not testing the "mesh" function and would rely on the
author to resolve any issues. We will disable the feature if "mesh"
break any of the normal WiFi operation and both ourselves and the author
are not be able to address the issues.

The best place to start is base on the latest iwlwifi driver which you
can find in the following location:

http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi-2.6.git;a=summary

Good luck and looking forward for your patches.

Thanks
Wey

On Thu, 2010-07-01 at 08:29 -0700, Iuri Diniz wrote:
> Is possible to add mesh support to iwlwifi (I have a intel wireless
> 4965AGN hardware) ?
> 
> if so, where can I get start?
> is this information
> http://linuxwireless.org/en/developers/Documentation/mac80211/API
> sufficient?
> 
> thanks in advance.
> 

