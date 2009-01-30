Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f21.google.com ([209.85.217.21]:42739 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756840AbZA3PII (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2009 10:08:08 -0500
Received: by gxk14 with SMTP id 14so393882gxk.13
        for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2009 07:08:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <b6c5339f0901300647y69bda19bq9c749b1c42334398@mail.gmail.com>
References: <498269D5.7080204@openwrt.org>
	 <40f31dec0901300017g2504e494mc75db9d9a0ffca7@mail.gmail.com>
	 <b6c5339f0901300647y69bda19bq9c749b1c42334398@mail.gmail.com>
Date: Fri, 30 Jan 2009 17:08:06 +0200
Message-ID: <40f31dec0901300708t294d169cle5f265ccf397493f@mail.gmail.com> (sfid-20090130_160814_961934_9E84DFA1)
Subject: Re: [PATCH,RFC 0/2] ath5k: implement tx power calibration on
	ar2413/5413
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/1/30 Bob Copeland <me@bobcopeland.com>:
> On Fri, Jan 30, 2009 at 3:17 AM, Nick Kossifidis <mickflemm@gmail.com> wrote:
>> I'm sending some patches that update phy.c, initvals.c and reset.c etc
>> today and i'll merge this one with RF5111/RF5112 pcdac stuff and tpc
>> support asap to have power table support for all chips. We also need
>> to work out regulatory stuff before we fully enable tx power support
>> so i have to test this on a spectrum analyzer.
>
> Speaking of regulatory, I had started adding the 802.11d stuff from
> ath9k already, but I haven't gotten to the point of even compiling it
> yet.  Want me to continue on it?  Probably can have something to show
> this weekend.
>

That 'll be great !!


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
