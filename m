Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:34260 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbbELFDn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2015 01:03:43 -0400
Received: by wicmc15 with SMTP id mc15so44027756wic.1
        for <linux-wireless@vger.kernel.org>; Mon, 11 May 2015 22:03:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJa-X96KPw6dY0pK1zc8UD4TdQcG0KuA3m6DSueVVyK-VPhn9g@mail.gmail.com>
References: <CAJa-X95EBdGASnz3KAdYz5R6w5g-a=dBy5VCZYwHp6SzQ+gUSw@mail.gmail.com>
	<CA+BoTQkFSQe0di1vqqB5cAPKaizRkBT5cu4fA8dQ_uR_a2HdJw@mail.gmail.com>
	<CAJa-X96spUg7+EZqH-Mv3s7OzbHzmXmcZ7uOw1KvPShexW6D_w@mail.gmail.com>
	<CA+BoTQ=Qpws=928TZe22Ds-UO_qQJ2Om+=DW=VUNUS59o1BQAA@mail.gmail.com>
	<CAJa-X96KPw6dY0pK1zc8UD4TdQcG0KuA3m6DSueVVyK-VPhn9g@mail.gmail.com>
Date: Tue, 12 May 2015 07:03:42 +0200
Message-ID: <CA+BoTQ=bqHPrdgGVfSfdJa5vobDBRdxRwMR_wJzUj4Z9WjotoQ@mail.gmail.com> (sfid-20150512_070346_841392_402BF345)
Subject: Re: Ath10 firmware crashing in Monitor mode(Sniffer mode)
From: Michal Kazior <michal.kazior@tieto.com>
To: s prasad <sprasad.kandregula@gmail.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11 May 2015 at 23:27, s prasad <sprasad.kandregula@gmail.com> wrote:
> Tested as you suggested, however didn't help. Please find attached log
> files for each firmware type.
>
> While executing following commands in sequence, captured dmesg. I hope
> those logs will help. If not please let me know.

Thanks!

Apparently I've missed from your original email the fact that you're
trying to inject packets. This isn't supported in ath10k.


Michał
