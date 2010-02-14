Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:37671 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab0BNTvI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Feb 2010 14:51:08 -0500
Received: by fxm27 with SMTP id 27so517076fxm.25
        for <linux-wireless@vger.kernel.org>; Sun, 14 Feb 2010 11:51:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100214191126.GA13637@jm.kir.nu>
References: <912ec82a1002140957p6959c030h2b33fd9646cfd67d@mail.gmail.com>
	<69e28c911002141046r70d8bcf2g6a8db7afbbef837@mail.gmail.com>
	<20100214191126.GA13637@jm.kir.nu>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sun, 14 Feb 2010 20:50:44 +0100
Message-ID: <69e28c911002141150t66d2c98dia3730deaac9a7cbc@mail.gmail.com>
Subject: Re: good wlan: sniffer that does not need a windows machine ?
To: Jouni Malinen <j@w1.fi>
Cc: Neshama Parhoti <pneshama@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/2/14 Jouni Malinen <j@w1.fi>:
> On Sun, Feb 14, 2010 at 07:46:04PM +0100, Gábor Stefanik wrote:
>> Monitoring in general works in almost all linux drivers (the Alfa
>> AWUS036H is perhaps the best for this purpose) - however, there is no
>> known way to monitor 802.11n packets on Linux (due to problems with
>> the mac80211 stack not passing 802.11n frames to monitor interfaces?).
>
> Known to whom? ;-) mac80211 passes 802.11n packet just fine to monitor
> interfaces and as an example, I'm using ath9k as a wireless sniffer for
> IEEE 802.11g/a/n. The radiotap headers may not show all parameters at
> this point, but there is ongoing work to extend that
>
>> Currently, the only way to sniff 802.11n packets is the AirPcap NX on
>> Windows.
>
> Yeah, right..

That was the last information I had - I didn't know someone has fixed
passing 802.11n frames to monitor interfaces.

BTW are A-MPDU frames also reported on monitor interfaces now?

>
> --
> Jouni Malinen                                            PGP id EFC895FA
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
