Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:37579 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757046AbYBDUBK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2008 15:01:10 -0500
Received: by wa-out-1112.google.com with SMTP id v27so3105278wah.23
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2008 12:01:09 -0800 (PST)
Message-ID: <1ba2fa240802041201o11107a8o14b969bacdf5345@mail.gmail.com> (sfid-20080204_200116_589977_5FD2BA17)
Date: Mon, 4 Feb 2008 22:01:09 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Kalle Valo" <kalle.valo@nokia.com>
Subject: Re: cfg80211 API changes
Cc: "Sam Leffler" <sam@errno.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>
In-Reply-To: <87zlug4m8p.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1ba2fa240802030539h132c7365g1bc1c20b1c560c0@mail.gmail.com>
	 <1ba2fa240802030555v28873634wceff4ecea67d3530@mail.gmail.com>
	 <1202049444.4188.125.camel@johannes.berg>
	 <1ba2fa240802030651x58ab6c63yd1b4d9ccaa2ecd42@mail.gmail.com>
	 <87ve55b74j.fsf@nokia.com> <47A74923.8040201@errno.com>
	 <87zlug4m8p.fsf@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 4, 2008 8:20 PM, Kalle Valo <kalle.valo@nokia.com> wrote:
> Sam Leffler <sam@errno.com> writes:
>
> >>> I see.  Rate scale algorithm only tels FW from what rate to start
> >>> transmission. FW is responsible to do downscaling.  Which is quite
> >>> reasonable as retransmission is real time process. Instead of
> >>> retransmitting on the same rate FW downscales. T X response provides
> >>> to the rate scaling algorithm the successful rate.
> >>
> >> I just want to point out this is an important feature when the bus is
> >> very slow, for example SPI bus in embedded devices. Retransfering
> >> frames through SPI for every rate restransmit would make such a device
> >> extremely slow.
> >
> > I don't know of a part that does repeated DMA to implement retransmit;
> > do you have an example?
>
> Asking me? No, I have never heard of such a device.
>
Actually what is probably happening with some devices, I'm not sure
though, they retries in FW/HW but do not downscale.

Tomas

> Kalle Valo
>
