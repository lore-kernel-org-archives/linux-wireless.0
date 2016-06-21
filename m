Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56074 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbcFUJfr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2016 05:35:47 -0400
Message-ID: <1466501738.3170.10.camel@sipsolutions.net> (sfid-20160621_113611_597327_93F8DBF8)
Subject: Re: [RESEND PATCH 1/3] rfkill: Create "rfkill-airplane-mode" LED
 trigger
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Machek <pavel@ucw.cz>,
	=?ISO-8859-1?Q?Jo=E3o?= Paulo Rechi Vita <jprvita@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Darren Hart <dvhart@infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	platform-driver-x86@vger.kernel.org, linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux@endlessm.com,
	=?ISO-8859-1?Q?Jo=E3o?= Paulo Rechi Vita
	<jprvita@endlessm.com>
Date: Tue, 21 Jun 2016 11:35:38 +0200
In-Reply-To: <20160613212116.GA10478@amd>
References: <1462199948-6424-2-git-send-email-jprvita@endlessm.com>
 <20160504072936.GB17045@amd>
 <1463045572.13313.21.camel@sipsolutions.net>
 <20160519071639.GB17077@amd>
 <1465476194.3442.21.camel@sipsolutions.net>
 <CA+A7VXXP3TYuk4Vvgc8YvxPFo06GG6WpyLJS+2vMLzr0iKQgsA@mail.gmail.com>
 <20160613190048.GA17101@amd>
 <CA+A7VXXOfN1Td2T6uiunWZMS4gvS5sHDzPiDp9VEdx+OPJpSmA@mail.gmail.com>
 <20160613210109.GA9303@amd>
 <CA+A7VXWdt16KHNx0n9jnpimCvN9dV38kb6smTbGWaJYo5VYcOQ@mail.gmail.com>
	 <20160613212116.GA10478@amd>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-06-13 at 23:21 +0200, Pavel Machek wrote:
> 
> (Actually, "::wifi" is super confusing, I'd expect that to be a led
> that blinks when wifi is active.)

Agree with that, yeah, that'd be confusing.

> Well... "airplane" is quite confusing. I'd we use "rfkill" for
> disabling radios, and I believe we should stick with that.
> 
> But small problem might be polarity. You may need both "::rfkill" and
> "::not-rfkill".

I'd argue that "airplane" matches better what you're likely to find on
the chassis of the system.

In either case I think the suffixes should be documented, for both
future kernel and application developers.

johannes
