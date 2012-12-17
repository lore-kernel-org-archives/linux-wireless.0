Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47162 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab2LQCad (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2012 21:30:33 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so2933256eek.19
        for <linux-wireless@vger.kernel.org>; Sun, 16 Dec 2012 18:30:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANa_0w2mShPgK4VwSzAFh+BSsxU5xYmWxogTcz_ZpVdj1seKgg@mail.gmail.com>
References: <CANa_0w2mShPgK4VwSzAFh+BSsxU5xYmWxogTcz_ZpVdj1seKgg@mail.gmail.com>
Date: Sun, 16 Dec 2012 21:30:32 -0500
Message-ID: <CANa_0w1YusGWqpgTRZ5Xxq0dzKVuZJUKTFccv6zPLekfG+NntA@mail.gmail.com> (sfid-20121217_033037_695556_7A31D3FA)
Subject: Re: txpower anything you make db.txt say ?
From: Jason Mclaughlin <mcjason@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

to better word myself... what i meant was, with the ath9k driver....
you're tx power seems to go as high as you say your limit is in db.txt

On Sat, Dec 15, 2012 at 10:29 PM, Jason Mclaughlin <mcjason@gmail.com> wrote:
>  was wondering... with a AEUS036NHA wireless adapater (ath9k), why
> does it seem like I can set the power arbitrarily higher if I make my
> own regulatory.bin
> from the crda package. I doubt for real that's the power since the
> adapater is rated at 1000mw afaik.
>
> I wanted to test if it was really having more power than 20db when I
> found out how to do that, but I suspiciously though it was just saying
> it's as high
> as you make db.txt say. This seems true at a whopping 48db (I never
> did anything like connect to someone, just rebooted at turned it back
> to 30).
>
> Also wanted to know, does it really do 30db? I noticed between two
> adapaters a mild improvement when setting it higher than 20 but it's
> hard to tell.
>
>
> root@debian:/home/jason# iwconfig
> wlan2     IEEE 802.11bgn  ESSID:off/any
>           Mode:Managed  Access Point: Not-Associated   Tx-Power=48 dBm
>           Retry  long limit:7   RTS thr:off   Fragment thr:off
>           Encryption key:off
>           Power Management:off
>
> eth0      no wireless extensions.
>
> lo        no wireless extensions.
>
> wlan0     IEEE 802.11bgn  ESSID:off/any
>           Mode:Managed  Access Point: Not-Associated   Tx-Power=16 dBm
>           Retry  long limit:7   RTS thr:off   Fragment thr:off
>           Encryption key:off
>           Power Management:off
