Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:39928 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754759AbZIAQdM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 12:33:12 -0400
Date: Tue, 1 Sep 2009 19:33:00 +0300
From: Jouni Malinen <j@w1.fi>
To: "Luis R. Rodriguez" <lrodriguez@Atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v2 6/7] wireless: update mac80211 kconfig entry
Message-ID: <20090901163300.GA29047@jm.kir.nu>
References: <1251820465-11104-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1251820465-11104-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 01, 2009 at 08:54:25AM -0700, Luis R. Rodriguez wrote:
> This updates the mac80211 kconfig entry to clarify
> what it is and refer people to our wireless wiki for
> more documentation.

> diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig

> -	tristate "Generic IEEE 802.11 Networking Stack (mac80211)"
> +	tristate "mac80211 - SoftMAC device support"

Uh.. Do we really need to call this SoftMAC or well have that in the
title? I prefer the current text or if you want to, just move the
mac80211 into the beginning..


> +	  This option enables support for a framework used by IEEE-802.11

s/IEEE-802.11/IEEE 802.11/

> +	  SoftMAC devices. SoftMAC devices allow for a finer control of the

Again, I don't really like the term "SoftMAC" here..

> +	  hardware, allowing for 802.11 frame management to be done in software
> +	  for them, for both parsing and generation of 802.11 wireless frames.
> +	  Most 802.11 devices today tend to be of this type.

s/802.11/IEEE 802.11/g

> +	  If you have new userspace utitlities which support nl80211 you do not

s/utitlities/utilities/

> +	  need wireless-extensions to support a mac80211 device.

s/wireless-extensions/wireless extensions/

> +	  When built as a module it will be called as mac80211, if not sure
> +	  you should build this as a module.

s/, if/. If/

-- 
Jouni Malinen                                            PGP id EFC895FA
