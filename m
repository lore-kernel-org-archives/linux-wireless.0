Return-Path: <SRS0=vb4L=PY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5134FC43387
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 12:24:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2759220657
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 12:24:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392460AbfAPMY4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Jan 2019 07:24:56 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:2240 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732749AbfAPMY4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Jan 2019 07:24:56 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 54E9B7F97F730575BFD7;
        Wed, 16 Jan 2019 20:24:52 +0800 (CST)
Received: from [127.0.0.1] (10.177.31.96) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.408.0; Wed, 16 Jan 2019
 20:24:49 +0800
Subject: Re: [PATCH] mac80211-next: remove duplicated include from virt_wifi.c
To:     Kalle Valo <kvalo@codeaurora.org>
References: <1545274285-143886-1-git-send-email-yuehaibing@huawei.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <cfdac00b-ea9a-1805-4668-64e44c523f6d@huawei.com>
Date:   Wed, 16 Jan 2019 20:24:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <1545274285-143886-1-git-send-email-yuehaibing@huawei.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

ping...

On 2018/12/20 10:51, YueHaibing wrote:
> Remove duplicated include.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/wireless/virt_wifi.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/virt_wifi.c b/drivers/net/wireless/virt_wifi.c
> index 64b2186..245d4d0 100644
> --- a/drivers/net/wireless/virt_wifi.c
> +++ b/drivers/net/wireless/virt_wifi.c
> @@ -14,11 +14,6 @@
>  #include <linux/etherdevice.h>
>  #include <linux/module.h>
>  
> -#include <net/cfg80211.h>
> -#include <net/rtnetlink.h>
> -#include <linux/etherdevice.h>
> -#include <linux/module.h>
> -
>  static struct wiphy *common_wiphy;
>  
>  struct virt_wifi_wiphy_priv {
> 
> 
> 
> 
> .
> 

