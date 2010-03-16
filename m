Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f198.google.com ([209.85.216.198]:64061 "EHLO
	mail-px0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932927Ab0CPDvz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Mar 2010 23:51:55 -0400
Received: by pxi36 with SMTP id 36so2469971pxi.21
        for <linux-wireless@vger.kernel.org>; Mon, 15 Mar 2010 20:51:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <19358.63849.107447.125247@gargle.gargle.HOWL>
References: <1268459216-22372-1-git-send-email-lrodriguez@atheros.com>
	<20100315214338.GB4000@tux> <43e72e891003151625t795b8ecdr2ce2e6927e8632a4@mail.gmail.com>
	<20100315234909.GA2662@tux> <4B9EC85B.8070800@openwrt.org>
	<43e72e891003151655i7dc051d0lc1da26267e9c706@mail.gmail.com>
	<4B9ECB3E.3010802@openwrt.org> <43e72e891003151709r42745e27q6e42c131d202a4cb@mail.gmail.com>
	<20100316003856.GL8069@bombadil.infradead.org> <19358.63849.107447.125247@gargle.gargle.HOWL>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 15 Mar 2010 20:51:35 -0700
Message-ID: <43e72e891003152051i503c4e36je14ef17bbba6804d@mail.gmail.com>
Subject: Re: [PATCH v3 00/12] ath9k_hw: complete support for AR9271
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	Felix Fietkau <nbd@openwrt.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Vivek Natarajan <Vivek.Natarajan@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 15, 2010 at 8:22 PM, Sujith <Sujith.Manoharan@atheros.com> wrote:
> Luis R. Rodriguez wrote:
>> Hah, yeah that fixed this work around, it works fine with the below
>> patch, I went ahead and added the coverage class calllback while
>> at it.
>>
>> John this means I don't have to resend this series out, we can just
>> skip patch #4, that's all. I'll do one more review with our team and
>> get back to you on a final ACK for this series.
>>
>> Sujith, please review and consider integration of the below changes
>> on the ath9k_htc front.
>
> Integrate where ? I have no idea what is happening.

Into the ath9k_htc driver patch.

> Too many patch series floating around ..

Oh? Let me clarify.

1 - ath9k_htc
2 - hw code changes
3 - hw deinit fix

I've split up patch #2 into individual ones with a few changes. I also
merged patch #3 into this series because I need these patches in order
to continue doing any work on ar93xx. So what I am referring to is
your patch #1, the ath9k_htc patch.

  Luis
