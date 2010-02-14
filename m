Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:57779 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab0BNSq1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Feb 2010 13:46:27 -0500
Received: by fxm27 with SMTP id 27so471482fxm.25
        for <linux-wireless@vger.kernel.org>; Sun, 14 Feb 2010 10:46:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <912ec82a1002140957p6959c030h2b33fd9646cfd67d@mail.gmail.com>
References: <912ec82a1002140957p6959c030h2b33fd9646cfd67d@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sun, 14 Feb 2010 19:46:04 +0100
Message-ID: <69e28c911002141046r70d8bcf2g6a8db7afbbef837@mail.gmail.com>
Subject: Re: good wlan: sniffer that does not need a windows machine ?
To: Neshama Parhoti <pneshama@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Monitoring in general works in almost all linux drivers (the Alfa
AWUS036H is perhaps the best for this purpose) - however, there is no
known way to monitor 802.11n packets on Linux (due to problems with
the mac80211 stack not passing 802.11n frames to monitor interfaces?).
Currently, the only way to sniff 802.11n packets is the AirPcap NX on
Windows.

Johannes, Luis, etc: what is the exact reason for not having 802.11n
monitoring support?

On Sun, Feb 14, 2010 at 6:57 PM, Neshama Parhoti <pneshama@gmail.com> wrote:
> Hi all,
>
> When developing mac80211 stuff, one sometimes need a WLAN packet
> sniffer that have more details than a simple packet information (e.g.
> info about packet rates, power lvl, etc..) which might need a
> dedicated hw sniffer + software (idealy it should support at least 11g
> and 11n, but if a hw supporting all four 11a,b,g,n exists in a
> reasonable price then why not).
>
> As far as I can see, most of these works only on windows (e.g. the one
> that is published on the wireshark site:
> http://www.cacetech.com/products/airpcap.html) they might be good, but
> that's not my taste.
>
> So - do you know any good solution that runs on linux ? preferably
> with open source drivers..
>
> Thanks!
> Ohad.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
