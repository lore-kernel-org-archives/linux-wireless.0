Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29437 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932617AbbELMT0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2015 08:19:26 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: s prasad <sprasad.kandregula@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: Ath10 firmware crashing in Monitor mode(Sniffer mode)
References: <CAJa-X95EBdGASnz3KAdYz5R6w5g-a=dBy5VCZYwHp6SzQ+gUSw@mail.gmail.com>
	<CA+BoTQkFSQe0di1vqqB5cAPKaizRkBT5cu4fA8dQ_uR_a2HdJw@mail.gmail.com>
	<CAJa-X96spUg7+EZqH-Mv3s7OzbHzmXmcZ7uOw1KvPShexW6D_w@mail.gmail.com>
	<CA+BoTQ=Qpws=928TZe22Ds-UO_qQJ2Om+=DW=VUNUS59o1BQAA@mail.gmail.com>
	<CAJa-X96KPw6dY0pK1zc8UD4TdQcG0KuA3m6DSueVVyK-VPhn9g@mail.gmail.com>
	<CA+BoTQ=bqHPrdgGVfSfdJa5vobDBRdxRwMR_wJzUj4Z9WjotoQ@mail.gmail.com>
Date: Tue, 12 May 2015 15:19:17 +0300
In-Reply-To: <CA+BoTQ=bqHPrdgGVfSfdJa5vobDBRdxRwMR_wJzUj4Z9WjotoQ@mail.gmail.com>
	(Michal Kazior's message of "Tue, 12 May 2015 07:03:42 +0200")
Message-ID: <87iobygf96.fsf@kamboji.qca.qualcomm.com> (sfid-20150512_141944_689788_826AA870)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

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

IMHO we should somehow warn the user or prevent that happening. Is there
a way to do that?

-- 
Kalle Valo
