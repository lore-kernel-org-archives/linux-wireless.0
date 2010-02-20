Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:37870 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756785Ab0BTSIi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Feb 2010 13:08:38 -0500
Date: Sat, 20 Feb 2010 20:08:32 +0200
From: Jouni Malinen <j@w1.fi>
To: Dennis Borgmann <dennis.borgmann@googlemail.com>
Cc: hostap@lists.shmoo.com, linux-wireless@vger.kernel.org
Subject: Re: ath9k+hostapd = "Could not set DTIM period for kernel driver"
Message-ID: <20100220180831.GA22238@jm.kir.nu>
References: <4B7EB318.3010707@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4B7EB318.3010707@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 19, 2010 at 04:49:44PM +0100, Dennis Borgmann wrote:

> Ok, now I get the card running, iw can access it (see below for output
> of iw list). I tried to make it become an accesspoint by using hostapd
> in version 0.6.10(self-compiled for this sole purpose).

> Could not set DTIM period for kernel driver
> wlan0: Unable to setup interface.

This is a bug in hostapd 0.6.10. I would suggest using the latest 0.7.x
version (currently, 0.7.1) when using AP mode with mac80211-based
drivers. Alternatively, you can get a fix for this from the current
snapshot of the 0.6.x branch (and eventually, 0.6.11, once that is
released).

-- 
Jouni Malinen                                            PGP id EFC895FA
