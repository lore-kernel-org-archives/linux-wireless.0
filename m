Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:45745 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759274Ab3GSLKx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jul 2013 07:10:53 -0400
Received: by mail-bk0-f41.google.com with SMTP id jc3so1609888bkc.28
        for <linux-wireless@vger.kernel.org>; Fri, 19 Jul 2013 04:10:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <871u6u4xkk.fsf@kamboji.qca.qualcomm.com>
References: <1374129193-3533-1-git-send-email-michal.kazior@tieto.com>
	<871u6u4xkk.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 19 Jul 2013 13:10:52 +0200
Message-ID: <CA+BoTQna=a66_g+_WG8mnENEDEiUcAysa-joeP-xmTM+mYfY=Q@mail.gmail.com> (sfid-20130719_131056_763980_7B4F0341)
Subject: Re: [PATCH 0/3] ath10k: fixes
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 July 2013 13:07, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> Hi,
>>
>> Here are some fixes for ath10k. The rts threshold
>> patch addresses my mistake in commit
>> 9aeb6fe53d1f0d6e58658484ce9ad7b59f0ef16b which
>> caused rts to be always enabled causing throughput
>> issues in some cases.
>>
>>
>> Michal Kazior (3):
>>   ath10k: prevent HTC from being used after stopping
>>   ath10k: fix memleak in mac setup
>>   ath10k: fix rts/fragmentation threshold setup
>
> Doesn't apply:
>
> Applying: ath10k: prevent HTC from being used after stopping
> Applying: ath10k: fix memleak in mac setup
> Applying: ath10k: fix rts/fragmentation threshold setup
> fatal: sha1 information is lacking or useless (drivers/net/wireless/ath/ath10k/mac.c).
> Repository lacks necessary blobs to fall back on 3-way merge.
> Cannot fall back to three-way merge.
> Patch failed at 0003 ath10k: fix rts/fragmentation threshold setup

Eww. Sorry about that (I did warn you though). Perhaps that's because
you skipped one of the recovery patches that git is confused now.

I'll resend the whole patchset rebased and with the HTC patch fixed.


Pozdrawiam / Best regards,
Micha³ Kazior.
