Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:16166 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932394AbbELMxc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2015 08:53:32 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	s prasad <sprasad.kandregula@gmail.com>
Subject: Re: Ath10 firmware crashing in Monitor mode(Sniffer mode)
References: <CAJa-X95EBdGASnz3KAdYz5R6w5g-a=dBy5VCZYwHp6SzQ+gUSw@mail.gmail.com>
	<CA+BoTQkFSQe0di1vqqB5cAPKaizRkBT5cu4fA8dQ_uR_a2HdJw@mail.gmail.com>
	<CAJa-X96spUg7+EZqH-Mv3s7OzbHzmXmcZ7uOw1KvPShexW6D_w@mail.gmail.com>
	<CA+BoTQ=Qpws=928TZe22Ds-UO_qQJ2Om+=DW=VUNUS59o1BQAA@mail.gmail.com>
	<CAJa-X96KPw6dY0pK1zc8UD4TdQcG0KuA3m6DSueVVyK-VPhn9g@mail.gmail.com>
	<CA+BoTQ=bqHPrdgGVfSfdJa5vobDBRdxRwMR_wJzUj4Z9WjotoQ@mail.gmail.com>
	<87iobygf96.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQkduFA78B70hyn9FNbyKX_Yd=9cH9notfEC93Owm9sRSg@mail.gmail.com>
Date: Tue, 12 May 2015 15:53:22 +0300
In-Reply-To: <CA+BoTQkduFA78B70hyn9FNbyKX_Yd=9cH9notfEC93Owm9sRSg@mail.gmail.com>
	(Michal Kazior's message of "Tue, 12 May 2015 14:34:57 +0200")
Message-ID: <87bnhqgdod.fsf@kamboji.qca.qualcomm.com> (sfid-20150512_145338_880988_87E36418)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 12 May 2015 at 14:19, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>
>>> On 11 May 2015 at 23:27, s prasad <sprasad.kandregula@gmail.com> wrote:
>>>> Tested as you suggested, however didn't help. Please find attached log
>>>> files for each firmware type.
>>>>
>>>> While executing following commands in sequence, captured dmesg. I hope
>>>> those logs will help. If not please let me know.
>>>
>>> Thanks!
>>>
>>> Apparently I've missed from your original email the fact that you're
>>> trying to inject packets. This isn't supported in ath10k.
>>
>> IMHO we should somehow warn the user or prevent that happening. Is there
>> a way to do that?
>
> We could add an extra condition in ath10k_tx() to drop/free packets
> immediately and warn if an injection attempt is made.

Yeah, that would be really good to have.

-- 
Kalle Valo
