Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52613 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757774Ab1EZPET convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 May 2011 11:04:19 -0400
Received: by pzk9 with SMTP id 9so341430pzk.19
        for <linux-wireless@vger.kernel.org>; Thu, 26 May 2011 08:04:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTinJDgKPEkiBh=kxBddn0ovcJkU26w@mail.gmail.com>
References: <BANLkTimrSD-zB5q+oM=8HkZ1nsTUNEG81g@mail.gmail.com>
	<BANLkTinaz4tmMSTRN7RJgYjOvchLY9NKog@mail.gmail.com>
	<BANLkTin=+9jZvm0RjBN0VGG50EXsnqcdvQ@mail.gmail.com>
	<BANLkTikavLsFOizFG1RieEZNwngBj5Bg0w@mail.gmail.com>
	<BANLkTi=HQe_sVQOcsNN6CUJUEQDpqr2y=g@mail.gmail.com>
	<BANLkTi=VKU_0+unoj3oUEsvhN7ZoPbivzg@mail.gmail.com>
	<BANLkTinJDgKPEkiBh=kxBddn0ovcJkU26w@mail.gmail.com>
Date: Thu, 26 May 2011 20:34:19 +0530
Message-ID: <BANLkTi=ZKYxV_WjbTV9s2_vbZR+UKDrhqQ@mail.gmail.com> (sfid-20110526_170434_413612_45E966CF)
Subject: Re: [ath9k-devel] [PATCH] ath9k: Fix Kiwi (AR9287) initial calibration
From: Mohammed Shafi <shafi.ath9k@gmail.com>
To: Adrian Chadd <adrian@freebsd.org>
Cc: linux-wireless@vger.kernel.org,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 26, 2011 at 8:26 PM, Adrian Chadd <adrian@freebsd.org> wrote:
> On 26 May 2011 22:48, Mohammed Shafi <shafi.ath9k@gmail.com> wrote:
>
>>> I hazard a guess that the rx calibration will affect RX sensitivity,
>>> maybe CRC errors? Or maximum link distance?
>>
>> Hmmm ok, if you got a chip please test it. I will be very happy if
>> this patch improves some performance or  reduces some CRC errors :) I
>> will also look into this
>
> Well I've just brought up AR9287 support on FreeBSD with this RX
> calibration change and initial tests are promising.
>
> I unfortunately don't have anything yet w/ mini-PCIe that dual-boots
> Linux so I can't easily test ath9k out.
>
> Hence why I was asking for someone to please investigate for me :)

no problem, sure

>
> Thanks,
>
> Adrian
>
