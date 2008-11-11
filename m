Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:48922 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689AbYKKWW5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2008 17:22:57 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [RFC PATCH 4/4] net/ieee80211 -> drivers/net/ipw2x00/libipw_* rename
Date: Tue, 11 Nov 2008 23:22:33 +0100
Cc: linux-wireless@vger.kernel.org
References: <> <1226440265-21240-3-git-send-email-linville@tuxdriver.com> <1226440265-21240-4-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1226440265-21240-4-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200811112322.33623.mb@bu3sch.de> (sfid-20081111_232301_889303_BF257402)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 11 November 2008 22:51:05 John W. Linville wrote:
> +config LIBIPW
> +	tristate
> +	select WIRELESS_EXT
> +	select CRYPTO
> +	select CRYPTO_ARC4
> +	select CRYPTO_ECB
> +	select CRYPTO_AES
> +	select CRYPTO_MICHAEL_MIC
> +	select CRYPTO_ECB
> +	select CRC32
> +	select LIB80211
> +	select LIB80211_CRYPT_WEP
> +	select LIB80211_CRYPT_TKIP
> +	select LIB80211_CRYPT_CCMP
> +	---help---
> +	This option enables the hardware independent IEEE 802.11
> +	networking stack.  This component is deprecated in favor of the
> +	mac80211 component.

Let's remove this helptext, or replace it by something that's actually true. ;)
	---help---
	  This option enables common routines for the IPW2100 and IPW2200 drivers.

-- 
Greetings Michael.
