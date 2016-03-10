Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:32864 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbcCJCPU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 21:15:20 -0500
Received: by mail-oi0-f51.google.com with SMTP id d205so50734876oia.0
        for <linux-wireless@vger.kernel.org>; Wed, 09 Mar 2016 18:15:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56E08615.9060208@lwfinger.net>
References: <56E08615.9060208@lwfinger.net>
Date: Wed, 9 Mar 2016 18:15:19 -0800
Message-ID: <CAC0d7Bi9VEN2zADV24DyhkZCp-mgLtDDXODUMfHoVzC0is7xMA@mail.gmail.com> (sfid-20160310_031522_982940_7788D561)
Subject: Re: New firmware for RT2870
From: quarkverse <quarkverse@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>, dan.g.tob@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have an RT5370 adapter from Panda Wireless and use it on my Ubuntu
14.04 laptop.
It is working fine on my laptop.

>From my laptop:
rt2x00lib_request_firmware: Info - Firmware detected - version: 0.29

I didn't see the warnings reported in the Bug 114151.

Just curious how to test version 0.36 on my laptop.

Thanks.

Alan

On Wed, Mar 9, 2016 at 12:22 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> In https://bugzilla.kernel.org/show_bug.cgi?id=114151, the OP reports
> improved stability and performance for an RT5370 using a newer firmware that
> came with the driver CD. The logs show this to be version 0.36, whereas the
> version now in linux-firmware is version 0.29.
>
> I downloaded the firmware from b.k.o. It had very little effect on my
> no-name adapter with ID 148f:3070. It still gets ping losses of 10-15%.
>
> Should this new version be submitted to linux-firmware? Its provenance seems
> to be sketchy, but submission would likely be legal.
>
> Larry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
