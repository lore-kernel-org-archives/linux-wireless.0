Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.228]:27488 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbYIKOUR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 10:20:17 -0400
Received: by wr-out-0506.google.com with SMTP id 69so217163wri.5
        for <linux-wireless@vger.kernel.org>; Thu, 11 Sep 2008 07:20:15 -0700 (PDT)
Message-ID: <40f31dec0809110720x38902672pc60426a7178de5e3@mail.gmail.com> (sfid-20080911_162022_041775_07D7D979)
Date: Thu, 11 Sep 2008 17:20:15 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Martin Michlmayr" <tbm@cyrius.com>
Subject: Re: [ath5k-devel] ath5k: bad udelay call, build failure on ARM
Cc: "John W. Linville" <linville@tuxdriver.com>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
In-Reply-To: <20080910093638.GA16874@deprecation.cyrius.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080825115715.GA13506@deprecation.cyrius.com>
	 <20080825190811.GC17297@tuxdriver.com>
	 <40f31dec0808251236qad2118dv2b781b147d366415@mail.gmail.com>
	 <20080910093638.GA16874@deprecation.cyrius.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/9/10 Martin Michlmayr <tbm@cyrius.com>:
> * Nick Kossifidis <mickflemm@gmail.com> [2008-08-25 22:36]:
>> > There are "udelay(2300)" calls in phy.c and hw.c.  How important is
>> > that exact number?  Could those be replaced by mdelay(3) instead?
>> >
>> > Of course, looking in include/linux/delay.h, mdelay(3) may still
>> > translate to __bad_udelay on arm.  It would be nice if the ARM guys
>> > and delay.h could at least agree on the maximum value allowed to be
>> > passed to udelay...
>> >
>> > John
>>
>> Sorry for that i just haven't tested 5210 code much (these are older
>> chips that need more delay). I'll do some tests asap and tweak this
>> value to be in range.
>
> Did you have a chance to do these tests yet?

Next week i hope, sorry for the delay ;-(



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
