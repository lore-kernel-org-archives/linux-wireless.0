Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:46942 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771AbZBDOeG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 09:34:06 -0500
Message-ID: <20090204093403.p42hfdbz4k0w0g0o-cebfxv@webmail.spamcop.net> (sfid-20090204_153411_497028_C093FE03)
Date: Wed, 04 Feb 2009 09:34:03 -0500
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] Document CONFIG_DRIVER_NL80211 in
	wpa_supplicant/defconfig
References: <20090204062021.12891.96607.stgit@ct.roinet.com>
	<20090204062037.12891.4454.stgit@ct.roinet.com>
	(sfid-20090204_072101_015392_5CF80812)
	<1233744755.3992.2.camel@johannes.local>
In-Reply-To: <1233744755.3992.2.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Johannes Berg <johannes@sipsolutions.net>:

> On Wed, 2009-02-04 at 01:20 -0500, Pavel Roskin wrote:
>> Put it after CONFIG_DRIVER_WEXT, as it's the new Linux wireless API.
>> Move comments about kernel includes next to CONFIG_DRIVER_NL80211, away
>> from CONFIG_CLIENT_MLME.
>
> Eh, no? The kernel includes are not required for nl80211 if everything
> is set up correctly, or maybe for client mlme only?

You are right, it looks like new kernel headers are no longer needed.   
The only header from the kernel is linux/if_ether.h, but it has been  
in the kernel for a long time.

Then let's add CONFIG_DRIVER_NL80211 (maybe even enabled by default)  
and remove the comments after CONFIG_CLIENT_MLME.

-- 
Regards,
Pavel Roskin
