Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:55964 "EHLO
        mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750715AbdJBHgy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Oct 2017 03:36:54 -0400
Received: by mail-qk0-f175.google.com with SMTP id q8so4338980qkl.12
        for <linux-wireless@vger.kernel.org>; Mon, 02 Oct 2017 00:36:54 -0700 (PDT)
Subject: Re: [PATCH 01/11] ath10k_sdio: sdio htt data transfer fixes
To: silexcommon@gmail.com, ath10k@lists.infradead.org
References: <1506793068-27445-1-git-send-email-alagusankar@silex-india.com>
 <1506793068-27445-2-git-send-email-alagusankar@silex-india.com>
Cc: linux-wireless@vger.kernel.org,
        Alagu Sankar <alagusankar@silex-india.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <59D1EC94.2020307@broadcom.com> (sfid-20171002_093510_725557_8CB6BAA5)
Date: Mon, 2 Oct 2017 09:36:52 +0200
MIME-Version: 1.0
In-Reply-To: <1506793068-27445-2-git-send-email-alagusankar@silex-india.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/30/2017 7:37 PM, silexcommon@gmail.com wrote:
> From: Alagu Sankar <alagusankar@silex-india.com>
>

[...]

>
> Signed-off-by: Alagu Sankar <alagusankar@silex-india.com>

Not really have a specific remark for this patch, but for the entire 
series. These patches are sent using an anonymous email address, apart 
from 'silex' being in there, which does not show up in the certificate 
of origin. Just wondering if this is acceptable?

Regards,
Arend

> ---
>   drivers/net/wireless/ath/ath10k/core.c   | 20 +++++++++++++++++---
>   drivers/net/wireless/ath/ath10k/htt_rx.c |  6 ++++--
>   drivers/net/wireless/ath/ath10k/htt_tx.c | 24 +++++++++++++++++++-----
>   3 files changed, 40 insertions(+), 10 deletions(-)
