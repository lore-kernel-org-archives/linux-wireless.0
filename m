Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xenotime.net ([72.52.115.56]:53766 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753133Ab1AYSGq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jan 2011 13:06:46 -0500
Received: from xenotime.net ([2001:470:0:13c::4834:7338]) by xenotime.net for <linux-wireless@vger.kernel.org>; Tue, 25 Jan 2011 10:06:44 -0800
Message-ID: <48698.64.134.136.58.1295978804.squirrel@xenotime.net>
In-Reply-To: <4D3F0DBC.90302@lockie.ca>
References: <4D3F0DBC.90302@lockie.ca>
Date: Tue, 25 Jan 2011 10:06:44 -0800 (PST)
Subject: Re: LIBIPW
From: "Randy Dunlap" <rdunlap@xenotime.net>
To: "James" <bjlockie@lockie.ca>
Cc: "linux-wireless Mailing List" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Tue, January 25, 2011 9:51 am, James wrote:
> /usr/src/compat-wireless-2011-01-24 $ sudo make
> /usr/src/compat-wireless-2011-01-24/config.mk:202: "WARNING:
> CONFIG_CFG80211_WEXT will be deactivated or not working because kernel
> was compiled with CONFIG_WIRELESS_EXT=n. Tools using wext interface like
> iwconfig will not work. To activate it build your kernel e.g. with
> CONFIG_LIBIPW=m."
>
>
> $ sudo grep LIBIPW ../linux/.config
> ''
>
>
> What does LIBIPW depend on?
> I don't even see a choice to turn it on.

It's not a user-visible prompted symbol.
It's selected by IPW2100 or IPW2200.

Also, the help text for LIBIPW (in 2.6.37) says:

	This option enables the hardware independent IEEE 802.11
	networking stack.  This component is deprecated in favor of the
	mac80211 component.

-- 
~Randy

