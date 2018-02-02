Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:52145 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751585AbeBBKlM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Feb 2018 05:41:12 -0500
Received: by mail-wm0-f50.google.com with SMTP id r71so11675082wmd.1
        for <linux-wireless@vger.kernel.org>; Fri, 02 Feb 2018 02:41:11 -0800 (PST)
Subject: Re: [PATCH] ath10k: Support mgt frame per-chain rssi
To: greearb@candelatech.com, linux-wireless@vger.kernel.org
References: <1517533386-30766-1-git-send-email-greearb@candelatech.com>
Cc: ath10k@lists.infradead.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A744045.7020309@broadcom.com> (sfid-20180202_114117_015373_727B574E)
Date: Fri, 2 Feb 2018 11:41:09 +0100
MIME-Version: 1.0
In-Reply-To: <1517533386-30766-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/2/2018 2:03 AM, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> This provides per-chain rssh for management frames received

'rssh' should be 'rssi'.

Regards,
Arend

> over wmi.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>   drivers/net/wireless/ath/ath10k/wmi.c | 21 ++++++++++++++++++++-
>   drivers/net/wireless/ath/ath10k/wmi.h |  1 +
>   2 files changed, 21 insertions(+), 1 deletion(-)
