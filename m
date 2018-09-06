Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42518 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730187AbeIFUIX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 16:08:23 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Tomislav =?utf-8?Q?Po=C5=BEega?= <pozega.tomislav@gmail.com>
Cc: linux-firmware@kernel.org, linux-wireless@vger.kernel.org,
        ath9k-devel@qca.qualcomm.com, adrian@freebsd.org
Subject: Re: [EXTERNAL] [PATCH] ath9k_htc: add fw 1.4.1
References: <1536098037-3000-1-git-send-email-pozega.tomislav@gmail.com>
Date: Thu, 06 Sep 2018 18:32:16 +0300
In-Reply-To: <1536098037-3000-1-git-send-email-pozega.tomislav@gmail.com>
        ("Tomislav \=\?utf-8\?Q\?Po\=C5\=BEega\=22's\?\= message of "Tue, 4 Sep 2018
 23:53:57 +0200")
Message-ID: <8736um7ibj.fsf@kamboji.qca.qualcomm.com> (sfid-20180906_173223_473893_2A8B1D44)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomislav Po=C5=BEega <pozega.tomislav@gmail.com> writes:

> Add firmware v1.4.1 that supports up to 8 virtual APs and up
> to 16 (current limit, at least on AR9271) client interfaces.
> (1 AP + 15 STA, 4 AP + 12 STA etc)
>
> Signed-off-by: Tomislav Po=C5=BEega <pozega.tomislav@gmail.com>
> ---
>  ath9k_htc/htc_7010-1.4.1.fw |  Bin 0 -> 72812 bytes
>  ath9k_htc/htc_9271-1.4.1.fw |  Bin 0 -> 51008 bytes
>  2 files changed, 0 insertions(+), 0 deletions(-)
>  create mode 100644 ath9k_htc/htc_7010-1.4.1.fw
>  create mode 100644 ath9k_htc/htc_9271-1.4.1.fw

Is this is an official release from the open-ath9k-htc-firmware project
or just some custom build of yours? I'm asking because I don't see
anything in the master branch since January:

https://github.com/qca/open-ath9k-htc-firmware/commits/master

IMHO Adrian Chadd (CCed) should be the one pushing the ath9k_htc
firmware image to linux-firmware, unless the maintainer has changed of
course.

--=20
Kalle Valo
