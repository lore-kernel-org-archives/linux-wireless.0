Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43297 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113Ab0JCRYi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Oct 2010 13:24:38 -0400
Received: by iwn5 with SMTP id 5so5933927iwn.19
        for <linux-wireless@vger.kernel.org>; Sun, 03 Oct 2010 10:24:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1286125639-15137-4-git-send-email-nbd@openwrt.org>
References: <1286125639-15137-1-git-send-email-nbd@openwrt.org>
 <1286125639-15137-2-git-send-email-nbd@openwrt.org> <1286125639-15137-3-git-send-email-nbd@openwrt.org>
 <1286125639-15137-4-git-send-email-nbd@openwrt.org>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Sun, 3 Oct 2010 10:24:15 -0700
Message-ID: <AANLkTinm6RUk1jECQYdkyA+vD=-z+c=pA+T_kduTGwMw@mail.gmail.com>
Subject: Re: [PATCH 4/4] ath9k_hw: fix regression in ANI listen time calculation
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 3, 2010 at 10:07 AM, Felix Fietkau <nbd@openwrt.org> wrote:
>  wireless-testing
>  commit 37e5bf6535a4d697fb9fa6f268a8354a612cbc00
>  Author: Luis R. Rodriguez <lrodriguez@atheros.com>
>  Date:   Sat Jun 12 00:33:40 2010 -0400
>
>    ath9k_hw: fix clock rate calculations for ANI
>
> This commit accidentally broke clock rate calculation by doubling the
> calculated clock rate
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Thanks, are you aware of the impact, is this a stable regression fix?

  Luisa
