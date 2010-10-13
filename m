Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53092 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab0JMLcO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 07:32:14 -0400
Subject: Re: [RFC: WL1271 DC supprot on OMAP3EVM 2/5] ARM: Supported for
 Standard SDIO driver on OMAP3EVM for WL1271 DC
From: Johannes Berg <johannes@sipsolutions.net>
To: csanjay@mistralsolutions.com
Cc: linux-omap@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <1286967439-705-3-git-send-email-csanjay@mistralsolutions.com>
References: <1286967439-705-1-git-send-email-csanjay@mistralsolutions.com>
	 <1286967439-705-3-git-send-email-csanjay@mistralsolutions.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Oct 2010 13:32:01 +0200
Message-ID: <1286969521.3640.53.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-10-13 at 16:27 +0530, csanjay@mistralsolutions.com wrote:

> +config WL1271_WLAN
> +	tristate "WL1271 TI's SDIO based wireless card"
> +	select WIRELESS_EXT
> +	select CRYPTO
> +	select WEXT_SPY
> +	select WEXT_PRIV
> +	---help---
> +	This driver support both the standard Linux Wireless Extensions
> +	and TI's proprietary API, so both the Linux Wireless Tools and this
> +	module support 2.4 GHz 802.11 b/g/n standrd.

Err, no? For once, you aren't actually adding a driver, and secondly,
you don't get to add drivers that need WIRELESS_EXT or any of the other
wext crap outside staging.

johannes

