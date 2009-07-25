Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f228.google.com ([209.85.218.228]:48755 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbZGYRkL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jul 2009 13:40:11 -0400
Received: by bwz28 with SMTP id 28so1923198bwz.37
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2009 10:40:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090724235804.GB26729@bombadil.infradead.org>
References: <2da21fe50907241631o3bf02d35md09c341133f503d2@mail.gmail.com>
	<20090724235804.GB26729@bombadil.infradead.org>
From: Davide Pesavento <davidepesa@gmail.com>
Date: Sat, 25 Jul 2009 19:39:51 +0200
Message-ID: <2da21fe50907251039w1039b8bcuc182b7ff5a60ac05@mail.gmail.com>
Subject: Re: ath9k panic (ath_tx_rc_status)
To: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 25, 2009 at 01:58, Luis R.
Rodriguez<mcgrof@bombadil.infradead.org> wrote:
> On Sat, Jul 25, 2009 at 01:31:24AM +0200, Davide Pesavento wrote:
>> Hi,
>>
>> after the latest pull from wireless-testing
>> (2.6.31-rc4-wl-29133-g1addf37) I always get a kernel panic with the
>> ath9k driver. The panic happens as soon as I start wpa_supplicant
>> (with -Dnl80211) or NetworkManager. I think that the kernel spits out
>> some warnings (lockdep?) before crashing, but I haven't been able to
>> capture them.
>> This is a regression since my previous pull (2.6.31-rc3-wl... + something).
>
> Yup, wrong patch applied/sent/fuckup. Try the patch posted.
>
>  Luis
>

Yes, I can confirm the patch fixes the panic. Thanks!

Davide
