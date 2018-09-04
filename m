Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55264 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726093AbeIDJE2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 05:04:28 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Tomislav =?utf-8?Q?Po=C5=BEega?= <pozega.tomislav@gmail.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        ath9k_htc_fw@lists.infradead.org
Subject: Re: [PATCH 1/3] debug: use common debug for ack timeout output
References: <1535997033-16330-1-git-send-email-pozega.tomislav@gmail.com>
        <87tvn5sx6y.fsf@purkki.adurom.net>
Date: Tue, 04 Sep 2018 07:41:07 +0300
In-Reply-To: <87tvn5sx6y.fsf@purkki.adurom.net> (Kalle Valo's message of "Tue,
        04 Sep 2018 07:28:37 +0300")
Message-ID: <87lg8hswm4.fsf@purkki.adurom.net> (sfid-20180904_064114_726208_CC4E1A8B)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

> Tomislav Po=C5=BEega <pozega.tomislav@gmail.com> writes:
>
>> Move ack debug code to common-debug and adjust
>> ath9k/ath9k_htc debug for common ack output.
>
> Why? I guess to be able to get ack timeout with ath9k_htc, but please
> write the reason clearly in the commit log.
>
> Also the title prefix should be "ath9k:".

Also please don't CC ath9k_htc_fw list. They spam with "Your message to
ath9k_htc_fw awaits moderator approval" which is REALLY annoying. From
now on I'll drop them automatically.

--=20
Kalle Valo
