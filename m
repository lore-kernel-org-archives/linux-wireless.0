Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33192 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732593AbeITRrb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 13:47:31 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] brcmsmac: ap mode: update beacon when TIM changes
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180911172618.13049-1-alimjalnasrawy@gmail.com>
References: <20180911172618.13049-1-alimjalnasrawy@gmail.com>
To: Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>
Message-Id: <20180920120421.B886360BE3@smtp.codeaurora.org> (sfid-20180920_140424_764657_96F10B3C)
Date: Thu, 20 Sep 2018 12:04:21 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com> wrote:

> Beacons+TIM are created/updated for fw beaconing only when BSS_CHANGED_BEACON.
> This is not compliant with power-saving stations. 
> Fix it by updating beacon templates on mac80211 set_tim callback.
> Adresses the issue in:
> https://marc.info/?i=20180911163534.21312d08%20()%20manjaro
> 
> Signed-off-by: Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>

Arend, what do you think about this?

-- 
https://patchwork.kernel.org/patch/10596025/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
