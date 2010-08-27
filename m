Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:49032 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235Ab0H0V1V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 17:27:21 -0400
Message-ID: <4C782DB0.4060800@hauke-m.de>
Date: Fri, 27 Aug 2010 23:27:12 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	mcgrof@infradead.org
Subject: Re: [PATCH 0/7] compat-wireless: add support for kernel 2.6.24 and
 2.6.25
References: <1282934453-18093-1-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1282934453-18093-1-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 27.08.2010 20:40, schrieb Hauke Mehrtens:
> This series fixes some problems when compiling compat-wireless against 
> kernel 2.6.24 or 2.6.25. Now this should work for every driver selected 
> by default.
> "add ifdefs into compat_autoconf.h" extends gen-compat-autoconf.sh to
> handle some ifdef in config.mk.
> 
> This was compile tested with kernel 2.6.24 to 2.6.36.
> 
> Hauke Mehrtens (7):
>   compat-wireless: do not use needed_headroom
>   compat-wireless: fix patch stile.
>   compat-wireless: remove linux/gpio.h include
>   compat-wireless: multiple changes to config file
>   compat-wireless: rename CONFIG_IWLWIFI config symbol
>   compat-wireless: add ifdefs into compat_autoconf.h
>   compat-wireless: add support for kernel 2.6.24

These patches and the patch for compat should also go into stable. I
have tested then with origin/linux-2.6.36.y and they also worked on that
branch.

Hauke
