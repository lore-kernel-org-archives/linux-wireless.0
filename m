Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.243]:3362 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbYGTW0z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2008 18:26:55 -0400
Received: by an-out-0708.google.com with SMTP id d40so333935and.103
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2008 15:26:54 -0700 (PDT)
Message-ID: <43e72e890807201526x5490f598h8feb638b43a829cc@mail.gmail.com> (sfid-20080721_002659_538427_A8661131)
Date: Sun, 20 Jul 2008 15:26:53 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Felix Fietkau" <nbd@openwrt.org>
Subject: Re: [PATCH v3] ath9k: fix another endianness issue
Cc: linux-wireless@vger.kernel.org, ath9k-devel@atheros.com
In-Reply-To: <4883B5C1.7070208@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <48836863.7090008@openwrt.org> <4883B5C1.7070208@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 20, 2008 at 3:01 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> DMA descriptors must always be accessed in native endianness.
> With this patch and my previous series, Atheros AR9160 now
> works for me in STA mode (tested on an IXP4xx board, big-endian)
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
> sorry, my mail client broke the last one (whitespace crap)

Thanks!

Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>

  Luis
