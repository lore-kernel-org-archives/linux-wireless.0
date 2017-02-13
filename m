Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57152 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751604AbdBMJSV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Feb 2017 04:18:21 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Aaryn Coutanche <aaryncoutanche@gmail.com>
Cc: jes.sorensen@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8xxxu: Add (0x2357 0x0107) to the tested devices list.
References: <1486814067-9874-1-git-send-email-aaryncoutanche@gmail.com>
Date: Mon, 13 Feb 2017 11:18:17 +0200
In-Reply-To: <1486814067-9874-1-git-send-email-aaryncoutanche@gmail.com>
        (Aaryn Coutanche's message of "Sun, 12 Feb 2017 00:54:27 +1300")
Message-ID: <87o9y6bg9y.fsf@purkki.adurom.net> (sfid-20170213_101836_695002_5721488E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Aaryn Coutanche <aaryncoutanche@gmail.com> writes:

> From: Aaryn Coutanche <aaryncoutanche@gmail.com>
>
> ---
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 3 +++
>  1 file changed, 3 insertions(+)

Signed-off-by is missing, please read Documentation/SubmittingPatches.
Also write a short commit log and document the device you used to test
this etc.

-- 
Kalle Valo
