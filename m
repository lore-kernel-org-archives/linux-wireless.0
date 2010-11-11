Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:46208 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755105Ab0KKL4v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 06:56:51 -0500
Subject: Re: Ti's WL1271 on OMAP3EVM board with kernel version 2.6.36
From: Luciano Coelho <luciano.coelho@nokia.com>
To: raghunath <raghunath@airvod.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTikZD_1DUqkxQyGSLdaQS01Qg15+_TDkW3QuRuOt@mail.gmail.com>
References: <004701cb8191$e82c75e0$b88561a0$@com>
	 <AANLkTikZD_1DUqkxQyGSLdaQS01Qg15+_TDkW3QuRuOt@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Nov 2010 13:56:44 +0200
Message-ID: <1289476604.1606.36.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,


On Thu, 2010-11-11 at 12:45 +0100, raghunath wrote:
> I am working on OMAP3EVM board with Mistral wl1271 daughter board and using
> linux kernel 2.6.36 I am using wl1271 drivers and getting this error pls
> Let me know if any thing is wrong..

[...]

> [    2.614593] wl1271: mac80211 configure filter
> [    2.614624] wl1271: acx group address tbl
> [    2.614624] wl1271: cmd configure
> [    2.615173] AIRVOD __dev_change_flags   net/core/dev.c ret = 0
> [    2.621398] wl1271: elp work
> [    2.621398] wl1271: chip to elp
> [    2.621459] wl1271: mac80211 configure filter
> [    2.621490] wl1271: waking up chip from elp
> [    3.118377] wl1271: ERROR ELP wakeup timeout!
> [    3.122955] wl1271: mac80211 configure filter
> [    3.122985] wl1271: waking up chip from elp
> [    3.618469] wl1271: ERROR ELP wakeup timeout!

It seems that you need this patch:
http://git.kernel.org/?p=linux/kernel/git/luca/wl12xx.git;a=commit;h=e8f1046f716a71d3a4426a5103e39c70059b8d0a


-- 
Cheers,
Luca.

