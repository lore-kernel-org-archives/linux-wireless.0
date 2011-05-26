Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f173.google.com ([209.85.212.173]:33847 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab1EZOsb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 May 2011 10:48:31 -0400
Received: by pxi16 with SMTP id 16so463150pxi.4
        for <linux-wireless@vger.kernel.org>; Thu, 26 May 2011 07:48:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=HQe_sVQOcsNN6CUJUEQDpqr2y=g@mail.gmail.com>
References: <BANLkTimrSD-zB5q+oM=8HkZ1nsTUNEG81g@mail.gmail.com>
	<BANLkTinaz4tmMSTRN7RJgYjOvchLY9NKog@mail.gmail.com>
	<BANLkTin=+9jZvm0RjBN0VGG50EXsnqcdvQ@mail.gmail.com>
	<BANLkTikavLsFOizFG1RieEZNwngBj5Bg0w@mail.gmail.com>
	<BANLkTi=HQe_sVQOcsNN6CUJUEQDpqr2y=g@mail.gmail.com>
Date: Thu, 26 May 2011 20:18:30 +0530
Message-ID: <BANLkTi=VKU_0+unoj3oUEsvhN7ZoPbivzg@mail.gmail.com> (sfid-20110526_164834_181694_CF8B15B5)
Subject: Re: [ath9k-devel] [PATCH] ath9k: Fix Kiwi (AR9287) initial calibration
From: Mohammed Shafi <shafi.ath9k@gmail.com>
To: Adrian Chadd <adrian@freebsd.org>
Cc: linux-wireless@vger.kernel.org,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 26, 2011 at 7:41 PM, Adrian Chadd <adrian@freebsd.org> wrote:
> On 26 May 2011 21:15, Mohammed Shafi <shafi.ath9k@gmail.com> wrote:
>
>>> What about RX sensitivity/errors?
>>
>> should I look recv debug stats?
>
> I'm not a chip developer, so I don't really know. :)
>
> I hazard a guess that the rx calibration will affect RX sensitivity,
> maybe CRC errors? Or maximum link distance?

Hmmm ok, if you got a chip please test it. I will be very happy if
this patch improves some performance or  reduces some CRC errors :) I
will also look into this

>
>
> Adrian
>
