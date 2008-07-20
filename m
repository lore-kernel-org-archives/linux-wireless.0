Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.245]:8241 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbYGTN6S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2008 09:58:18 -0400
Received: by an-out-0708.google.com with SMTP id d40so319261and.103
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2008 06:58:17 -0700 (PDT)
Message-ID: <43e72e890807200658t1acb499dw7957f9f5d3befcb3@mail.gmail.com> (sfid-20080720_155820_460929_3580D12A)
Date: Sun, 20 Jul 2008 06:58:17 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Felix Fietkau" <nbd@openwrt.org>
Subject: Re: [PATCH 1/5] ath9k: fix bad udelay
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
In-Reply-To: <48833E93.5060702@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <48833E93.5060702@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 20, 2008 at 6:33 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> Replace udelay(3000) with mdelay(3), because udelay(3000) fails on
> some architectures, e.g. ARM
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

This is for 1-5, thanks.

Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>

  Luis
