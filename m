Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from caladan.dune.hu ([78.24.191.180]:50790 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932134AbcE2LgG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 May 2016 07:36:06 -0400
Received: from localhost (localhost [127.0.0.1])
	by arrakis.dune.hu (Postfix) with ESMTP id 491F7B932E1
	for <linux-wireless@vger.kernel.org>; Sun, 29 May 2016 13:35:59 +0200 (CEST)
Received: from mail-vk0-f45.google.com (mail-vk0-f45.google.com [209.85.213.45])
	by arrakis.dune.hu (Postfix) with ESMTPSA id C918AB932E0
	for <linux-wireless@vger.kernel.org>; Sun, 29 May 2016 13:35:41 +0200 (CEST)
Received: by mail-vk0-f45.google.com with SMTP id k1so137998141vka.3
        for <linux-wireless@vger.kernel.org>; Sun, 29 May 2016 04:35:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1464288752-6625-1-git-send-email-avinashp@quantenna.com>
References: <1464288752-6625-1-git-send-email-avinashp@quantenna.com>
From: Jonas Gorski <jogo@openwrt.org>
Date: Sun, 29 May 2016 13:35:20 +0200
Message-ID: <CAOiHx==C56Pj768bRX16VOaxj0Qf_oh5KXfhFJakT2zi-SokQQ@mail.gmail.com> (sfid-20160529_133620_494862_946E8C76)
Subject: Re: [PATCH] qtnfmac: announcement of new FullMAC driver for Quantenna chipsets
To: Avinash Patil <avinashp@quantenna.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	dlebed@quantenna.com, smaksimenko@quantenna.com,
	smatyukevich@quantenna.com, imitsyanko@quantenna.com,
	btherthala@quantenna.com, hwang@quantenna.com, krath@quantenna.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 26 May 2016 at 20:52, Avinash Patil <avinashp@quantenna.com> wrote:
> This patch adds support for new FullMAC WiFi driver for Quantenna
> QSR10G chipsets.
>
> QSR10G is Quantenna's 8x8, 160M, 11ac offering.
> QSR10G supports 2 simultaneous WMACs- one 5G and one 2G. 5G WMAC
> supports 160M, 8x8 configuration.
> FW supports 8 concurrent virtual interfaces on each WMAC.
>
> Patch introduces 2 new drivers- qtnfmac.ko for interfacing with
> kernel/cfg80211 and qtnfmac_pcie.ko for PCIe bus interface.

Nice to see this one, will you also provide a pearl-linux.lzma.img as
required for the firmware? What about cards in embedded devices, might
they require a uboot as well? Since requesting uboot seems to be
specifically supported by the card/firmware interface.

> This email, including its contents and any attachment(s), may contain confidential information of Quantenna Communications, Inc. and is solely for the intended recipient(s). If you may have received this in error, please contact the sender and permanently delete this email, its contents and any attachment(s).

You will need to remove this footer to be taken seriously, as
confidential information would be not GPL compatible, and "may
contain" means it is too risky to accept that.


Regards
Jonas
