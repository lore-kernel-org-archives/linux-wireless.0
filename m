Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3916 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809Ab3CERAs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Mar 2013 12:00:48 -0500
Message-ID: <513624B7.8010109@broadcom.com> (sfid-20130305_180054_155755_2318829F)
Date: Tue, 5 Mar 2013 18:00:39 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?SsOhbiBWZXNlbMO9?= <jano.vesely@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: BCM4313 problems connecting to AP since 3.8
References: <CA+K+NcR9tExM9y-yjH_MB=ZpjeeakMW2GozECg4Pejp54nkCjA@mail.gmail.com>
In-Reply-To: <CA+K+NcR9tExM9y-yjH_MB=ZpjeeakMW2GozECg4Pejp54nkCjA@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/04/13 22:47, Ján Veselý wrote:
> Hi,
>
> after upgrading to 3.8 I started running into a timeout problem on
> BCM4313 wifi using brcmsmac driver (compiled as module, x86_64).
> the card is unable to connect to ap after startup of resume.
> Although it eventually connects it takes a long time (several minutes)
> and dmesg log is spammed with:
>
> [  144.725431] wlan0: authenticate with 00:23:f8:8f:29:14
> [  144.727786] wlan0: capabilities/regulatory prevented using AP
> HT/VHT configuration, downgraded
> [  144.727820] wlan0: direct probe to 00:23:f8:8f:29:14 (try 1/3)
> [  144.930780] wlan0: direct probe to 00:23:f8:8f:29:14 (try 2/3)
> [  145.133855] wlan0: direct probe to 00:23:f8:8f:29:14 (try 3/3)
> [  145.336931] wlan0: authentication with 00:23:f8:8f:29:14 timed out
> [  151.217245] wlan0: authenticate with 00:23:f8:8f:29:14
>
> (30+ times in some cases)
>
> I tested 3.8.0/1/2 as well as 3.9.0-rc1 and the problem is present in
> all of them.
> returning back to 3.7.10 fixes the problem and the card connects
> without a single timeout message.
>
> the AP is an older adsl modem/hotspot and runs in 802.11g mode, my
> other machine (x86) with atheros chipset connects without any problems
> to the same AP on 3.8 kernel.
>
> let me know if I can provide more info

Well, for starters the dmesg output before the first spam occurrence 
would be good to have a look at. Could you provide that?

If you don't mind I changed Cc: to linux-wireless mailing list.

Gr. AvS
> Jan Vesely
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


