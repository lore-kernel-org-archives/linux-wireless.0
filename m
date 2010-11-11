Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lugano1.hostireland.com ([72.32.223.205]:42818 "EHLO
	lugano.hostireland.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751407Ab0KKOvj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 09:51:39 -0500
From: "raghunath" <raghunath@airvod.com>
To: "'Luciano Coelho'" <luciano.coelho@nokia.com>
Cc: <linux-wireless@vger.kernel.org>
References: <004701cb8191$e82c75e0$b88561a0$@com>	 <AANLkTikZD_1DUqkxQyGSLdaQS01Qg15+_TDkW3QuRuOt@mail.gmail.com> <1289476604.1606.36.camel@powerslave>
In-Reply-To: <1289476604.1606.36.camel@powerslave>
Subject: RE: Ti's WL1271 on OMAP3EVM board with kernel version 2.6.36
Date: Thu, 11 Nov 2010 20:21:34 +0530
Message-ID: <005101cb81af$f1e75280$d5b5f780$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luca,
I applied the patch which u have mentioned, but there is no change.

Raghu

-----Original Message-----
From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of Luciano Coelho
Sent: Thursday, November 11, 2010 5:27 PM
To: raghunath
Cc: linux-wireless@vger.kernel.org
Subject: Re: Ti's WL1271 on OMAP3EVM board with kernel version 2.6.36

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

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

