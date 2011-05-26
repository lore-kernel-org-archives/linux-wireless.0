Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:37077 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab1EZO4E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 May 2011 10:56:04 -0400
Received: by yia27 with SMTP id 27so312735yia.19
        for <linux-wireless@vger.kernel.org>; Thu, 26 May 2011 07:56:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=VKU_0+unoj3oUEsvhN7ZoPbivzg@mail.gmail.com>
References: <BANLkTimrSD-zB5q+oM=8HkZ1nsTUNEG81g@mail.gmail.com>
	<BANLkTinaz4tmMSTRN7RJgYjOvchLY9NKog@mail.gmail.com>
	<BANLkTin=+9jZvm0RjBN0VGG50EXsnqcdvQ@mail.gmail.com>
	<BANLkTikavLsFOizFG1RieEZNwngBj5Bg0w@mail.gmail.com>
	<BANLkTi=HQe_sVQOcsNN6CUJUEQDpqr2y=g@mail.gmail.com>
	<BANLkTi=VKU_0+unoj3oUEsvhN7ZoPbivzg@mail.gmail.com>
Date: Thu, 26 May 2011 22:56:03 +0800
Message-ID: <BANLkTinJDgKPEkiBh=kxBddn0ovcJkU26w@mail.gmail.com> (sfid-20110526_165608_788519_771884DD)
Subject: Re: [ath9k-devel] [PATCH] ath9k: Fix Kiwi (AR9287) initial calibration
From: Adrian Chadd <adrian@freebsd.org>
To: Mohammed Shafi <shafi.ath9k@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26 May 2011 22:48, Mohammed Shafi <shafi.ath9k@gmail.com> wrote:

>> I hazard a guess that the rx calibration will affect RX sensitivity,
>> maybe CRC errors? Or maximum link distance?
>
> Hmmm ok, if you got a chip please test it. I will be very happy if
> this patch improves some performance or  reduces some CRC errors :) I
> will also look into this

Well I've just brought up AR9287 support on FreeBSD with this RX
calibration change and initial tests are promising.

I unfortunately don't have anything yet w/ mini-PCIe that dual-boots
Linux so I can't easily test ath9k out.

Hence why I was asking for someone to please investigate for me :)

Thanks,

Adrian
