Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:33413 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222AbbELJbf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2015 05:31:35 -0400
Received: by oica37 with SMTP id a37so1074140oic.0
        for <linux-wireless@vger.kernel.org>; Tue, 12 May 2015 02:31:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQ=bqHPrdgGVfSfdJa5vobDBRdxRwMR_wJzUj4Z9WjotoQ@mail.gmail.com>
References: <CAJa-X95EBdGASnz3KAdYz5R6w5g-a=dBy5VCZYwHp6SzQ+gUSw@mail.gmail.com>
	<CA+BoTQkFSQe0di1vqqB5cAPKaizRkBT5cu4fA8dQ_uR_a2HdJw@mail.gmail.com>
	<CAJa-X96spUg7+EZqH-Mv3s7OzbHzmXmcZ7uOw1KvPShexW6D_w@mail.gmail.com>
	<CA+BoTQ=Qpws=928TZe22Ds-UO_qQJ2Om+=DW=VUNUS59o1BQAA@mail.gmail.com>
	<CAJa-X96KPw6dY0pK1zc8UD4TdQcG0KuA3m6DSueVVyK-VPhn9g@mail.gmail.com>
	<CA+BoTQ=bqHPrdgGVfSfdJa5vobDBRdxRwMR_wJzUj4Z9WjotoQ@mail.gmail.com>
Date: Tue, 12 May 2015 05:31:35 -0400
Message-ID: <CAJa-X945Xvn0jHQVcKn-pyYQVNpxXnqjOH_VHJv8pVwR4kFXcw@mail.gmail.com> (sfid-20150512_113147_159029_82DE91F5)
Subject: Re: Ath10 firmware crashing in Monitor mode(Sniffer mode)
From: s prasad <sprasad.kandregula@gmail.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	kvalo@qca.qualcomm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

May I know, is this firmware or driver constraint?
If somebody have patch for this, am ready to test it.

Thanks and Regards,
S Prasad

On Tue, May 12, 2015 at 1:03 AM, Michal Kazior <michal.kazior@tieto.com> wrote:
> On 11 May 2015 at 23:27, s prasad <sprasad.kandregula@gmail.com> wrote:
>> Tested as you suggested, however didn't help. Please find attached log
>> files for each firmware type.
>>
>> While executing following commands in sequence, captured dmesg. I hope
>> those logs will help. If not please let me know.
>
> Thanks!
>
> Apparently I've missed from your original email the fact that you're
> trying to inject packets. This isn't supported in ath10k.
>
>
> Michał



-- 
S Prasad Kandregula
