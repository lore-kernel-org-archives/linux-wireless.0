Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:58667 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbaAWJLT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 04:11:19 -0500
Received: by mail-ie0-f177.google.com with SMTP id at1so807615iec.22
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jan 2014 01:11:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKKnJbe=eBMzB3Bp7qkYvwSTr0x=g-bZkz9dQ6HUihZE5rc5iw@mail.gmail.com>
References: <CAKKnJbe=eBMzB3Bp7qkYvwSTr0x=g-bZkz9dQ6HUihZE5rc5iw@mail.gmail.com>
Date: Thu, 23 Jan 2014 10:11:18 +0100
Message-ID: <CAFED-jmUF9u=sLfVuCSy3rjmB4DM9x6BCLhJaq2CrY9MV6Wycg@mail.gmail.com> (sfid-20140123_101125_925693_E688EE9B)
Subject: Re: wlcore-spi crash
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: Charles <hobbesc7@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2014/1/22 Charles <hobbesc7@gmail.com>:
> I am building the TI wireless drivers from backports-3.12-1 for a 3.2 kernel.
>
> When I modprobe wlcore-spi I get a kernel crash.  Has anyone
> encountered this?  I found a similar problem here:
> http://marc.info/?l=linux-wireless&m=135212370625698&w=2
>
> I tried adding the patch mentioned there to backports-3.12-1, but I
> get this build error: "error: 'struct wl1271' has no member named
> 'set_power'"
>
> Here's the crash:
>
> [   98.325693] Unable to handle kernel NULL pointer dereference at
> virtual address 00000000
> [   98.334171] pgd = c0004000
> [   98.337031] [00000000] *pgd=00000000
> [   98.340791] Internal error: Oops: 80000007 [#1]
> [   98.345524] Modules linked in: wlcore_spi(O) wl12xx(O) wlcore(O)
> mac80211(O) cfg80211(O) compat(O) autofs4
> [   98.355661] CPU: 0    Tainted: G           O  (3.2.0)
> [   98.364120] PC is at 0x0
> [   98.366846] LR is at wl12xx_set_power_on+0x30/0x150 [wlcore]

I think this should help:
http://www.spinics.net/lists/linux-wireless/msg98589.html

BR
Janusz
