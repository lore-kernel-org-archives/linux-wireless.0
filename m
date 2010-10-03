Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:53082 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754616Ab0JCTIY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Oct 2010 15:08:24 -0400
Message-ID: <4CA8D4A3.9060403@openwrt.org>
Date: Sun, 03 Oct 2010 21:08:19 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 4/4] ath9k_hw: fix regression in ANI listen time calculation
References: <1286125639-15137-1-git-send-email-nbd@openwrt.org> <1286125639-15137-2-git-send-email-nbd@openwrt.org> <1286125639-15137-3-git-send-email-nbd@openwrt.org> <1286125639-15137-4-git-send-email-nbd@openwrt.org> <AANLkTinm6RUk1jECQYdkyA+vD=-z+c=pA+T_kduTGwMw@mail.gmail.com>
In-Reply-To: <AANLkTinm6RUk1jECQYdkyA+vD=-z+c=pA+T_kduTGwMw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-10-03 7:24 PM, Luis R. Rodriguez wrote:
> On Sun, Oct 3, 2010 at 10:07 AM, Felix Fietkau <nbd@openwrt.org> wrote:
>>  wireless-testing
>>  commit 37e5bf6535a4d697fb9fa6f268a8354a612cbc00
>>  Author: Luis R. Rodriguez <lrodriguez@atheros.com>
>>  Date:   Sat Jun 12 00:33:40 2010 -0400
>>
>>    ath9k_hw: fix clock rate calculations for ANI
>>
>> This commit accidentally broke clock rate calculation by doubling the
>> calculated clock rate
>>
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> 
> Thanks, are you aware of the impact, is this a stable regression fix?
I just checked, looks like this is a stable fix. The impact is that ANI
will probably pick settings with higher numbers of OFDM/CCK misdetects.
I'll resend with Cc: stable

- Felix
