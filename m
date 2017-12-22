Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:43362 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752549AbdLVQIp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Dec 2017 11:08:45 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "silexcommon@gmail.com" <silexcommon@gmail.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        Alagu Sankar <alagusankar@silex-india.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 03/11] ath10k_sdio: DMA bounce buffers for read write
Date: Fri, 22 Dec 2017 16:08:40 +0000
Message-ID: <87lghu9247.fsf@kamboji.qca.qualcomm.com> (sfid-20171222_170849_708853_D4F660FB)
References: <1506793068-27445-1-git-send-email-alagusankar@silex-india.com>
        <1506793068-27445-4-git-send-email-alagusankar@silex-india.com>
In-Reply-To: <1506793068-27445-4-git-send-email-alagusankar@silex-india.com>
        (silexcommon@gmail.com's message of "Sat, 30 Sep 2017 23:07:40 +0530")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

silexcommon@gmail.com writes:

> From: Alagu Sankar <alagusankar@silex-india.com>
>
> Some SD host controllers still need bounce buffers for SDIO data
> transfers. While the transfers worked fine on x86 platforms,
> this is found to be required for i.MX6 based systems.
>
> Changes are similar to and derived from the ath6kl sdio driver.
>
> Signed-off-by: Alagu Sankar <alagusankar@silex-india.com>

Why is the bounce buffer needed exactly, what are the symptoms etc? To
me this sounds like an ugly workaround for a SDIO controller driver bug.

--=20
Kalle Valo=
