Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50520 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab2FJQy5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jun 2012 12:54:57 -0400
Received: by wgbdr13 with SMTP id dr13so2424763wgb.1
        for <linux-wireless@vger.kernel.org>; Sun, 10 Jun 2012 09:54:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2716026.rMfCBzMpF9@flexo>
References: <1338933307-13446-1-git-send-email-hauke@hauke-m.de>
	<1338933307-13446-7-git-send-email-hauke@hauke-m.de>
	<2716026.rMfCBzMpF9@flexo>
Date: Sun, 10 Jun 2012 18:54:56 +0200
Message-ID: <CACna6rw_5dcR9tu_Nnq_0Z3u+KJ--Lmx7yi+uHJm-kJPepqrng@mail.gmail.com> (sfid-20120610_185510_656878_F592760E)
Subject: Re: [PATCH 6/8] bcma: handle SoCs in pmu initialization
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Florian Fainelli <florian@openwrt.org>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, linville@tuxdriver.com,
	b43-dev@lists.infradead.org, arend@broadcom.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/6/6 Florian Fainelli <florian@openwrt.org>:
> Hi Hauke,
>
> On Tuesday 05 June 2012 23:55:05 Hauke Mehrtens wrote:
>> The SoCs do not need any special handling in bcma_pmu_pll_init(),
>> bcma_pmu_resources_init(), bcma_pmu_swreg_init() and
>> bcma_pmu_workarounds. This patches suppresses some warnings in the log.
>
> This does not look like it scales very good, how about you turn the pr_err()
> into a pr_debug() so that developpers porting bcma on a new chip need to turn
> on the appropriate debug knobs to get the message?

debug sounds fine for me

-- 
Rafał
