Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f182.google.com ([209.85.216.182]:40675 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244Ab3J1TYk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 15:24:40 -0400
Received: by mail-qc0-f182.google.com with SMTP id n7so4145423qcx.27
        for <linux-wireless@vger.kernel.org>; Mon, 28 Oct 2013 12:24:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1382968966.17956.15.camel@jlt4.sipsolutions.net>
References: <CAJ-Vmok4rDn1Q5qCU2Oz=CVsqkJvYC0D+CmQL+WpwU+9qKHzrw@mail.gmail.com>
	<1382968966.17956.15.camel@jlt4.sipsolutions.net>
Date: Mon, 28 Oct 2013 12:24:38 -0700
Message-ID: <CAJ-Vmomsv52xc6-rwaBy9aZUsN3BaPeRTDBu8+bn2ov_Asb=1A@mail.gmail.com> (sfid-20131028_202450_759762_AECC8011)
Subject: Re: iwlegacy (4965) - what would 0x8000 as the completed TX rate indicate?
From: Adrian Chadd <adrian@freebsd.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

On 28 October 2013 07:02, Johannes Berg <johannes@sipsolutions.net> wrote:

[snip]

>> The status indicates things are transmitting and completing fine.
>>
>> So, any ideas what that 0x8000 rate in the rate completion means?
>
> I think that just means it used the other antenna and rate 0, since the
> bits 0x1c000 contain the antenna bitmap that was used (up to three can
> be used for each transmission)

Well, what's rate=0 mean?

And 0x8000 is bit 11 set, which is HT40. I definitely don't have HT40 enabled.


-a
