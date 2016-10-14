Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21206 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755693AbcJNHeU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Oct 2016 03:34:20 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Erik Stromdahl <erik.stromdahl@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 0/5] ath6kl: non WMI data service support
Date: Fri, 14 Oct 2016 07:34:15 +0000
Message-ID: <87k2dbbczu.fsf@kamboji.qca.qualcomm.com> (sfid-20161014_093423_903337_B2E2C34C)
References: <1476376769-4708-1-git-send-email-erik.stromdahl@gmail.com>
In-Reply-To: <1476376769-4708-1-git-send-email-erik.stromdahl@gmail.com> (Erik
        Stromdahl's message of "Thu, 13 Oct 2016 18:39:24 +0200")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Erik Stromdahl <erik.stromdahl@gmail.com> writes:

> This patch series is intended to prepare the ath6kl driver
> for newer chipsets that doesn't use the current WMI data
> endpoints for data traffic.
>
> The chipset I have been working with (and used for testing)
> is QCA6584. It is SDIO based (at least the variant I have
> been using) with 802.11p WAVE DSRC capabilities.
>
> This chipset is different from the AR600X family in that
> it does not use the WMI data services (service id's 0x101
> to 0x104 ) for data traffic.
> Instead it uses the HTT data service for data and wmi unified
> for control messages.
> It is also different when it comes to mailbox addresses
> and HTC header format as well, but these differences are not
> part of this patch series.

Do you have more patches implemented, like something already working or
have just started?

--=20
Kalle Valo=
