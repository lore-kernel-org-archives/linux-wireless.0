Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59E42C04A6A
	for <linux-wireless@archiver.kernel.org>; Thu,  3 Aug 2023 07:18:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233312AbjHCHSh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 3 Aug 2023 03:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbjHCHSg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2023 03:18:36 -0400
Received: from mail.nfschina.com (unknown [42.101.60.195])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 486E8272A;
        Thu,  3 Aug 2023 00:18:35 -0700 (PDT)
Received: from [172.30.11.106] (unknown [180.167.10.98])
        by mail.nfschina.com (Maildata Gateway V2.8.8) with ESMTPSA id 082FC60902F40;
        Thu,  3 Aug 2023 15:18:30 +0800 (CST)
Message-ID: <399a5407-d48a-089d-56ce-3ffe8eee9b2e@nfschina.com>
Date:   Thu, 3 Aug 2023 15:18:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH net-next 0/9] wifi: rsi: Remove some unnecessary
 conversions
Content-Language: en-US
To:     Julia Lawall <julia.lawall@inria.fr>
Cc:     kvalo@kernel.org, yuancan@huawei.com, simon.horman@corigine.com,
        marex@denx.de, peter@n8pjl.ca, johannes.berg@intel.com,
        alexander@wetzel-home.de, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
X-MD-Sfrom: yunchuan@nfschina.com
X-MD-SrcIP: 180.167.10.98
From:   yunchuan <yunchuan@nfschina.com>
In-Reply-To: <alpine.DEB.2.22.394.2308030908020.3083@hadrien>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2023/8/3 15:08, Julia Lawall wrote:
>
> On Thu, 3 Aug 2023, Wu Yunchuan wrote:
>
>> remove unnecessary (void*) conversions and other unnecessary
>> conversons in the directory drivers/net/wireless/rsi.
>>
>> Wu Yunchuan (9):
>>    wifi: rsi: Remove unnecessary (void*) conversions
>>    wifi: rsi: Remove unnecessary (void*) conversions
>>    wifi: rsi: Remove unnecessary conversions
>>    wifi: rsi: Remove unnecessary conversions
>>    wifi: rsi: Remove unnecessary (void*) conversions
>>    wifi: rsi: Remove unnecessary (void*) conversions
>>    wifi: rsi: Remove unnecessary (void*) conversions
>>    wifi: rsi: Remove unnecessary (void*) conversions
>>    wifi: rsi: Remove unnecessary (void*) conversions
> Shouldn't these have unique subject lines?
Oh, really sorry for this.
I will fix this and resend v2 soon.
Thanks for your reminder!

Wu Yunchuan

>
> julia
>
>>   drivers/net/wireless/rsi/rsi_91x_coex.c     | 11 +++---
>>   drivers/net/wireless/rsi/rsi_91x_debugfs.c  |  3 +-
>>   drivers/net/wireless/rsi/rsi_91x_hal.c      |  2 +-
>>   drivers/net/wireless/rsi/rsi_91x_mac80211.c |  4 +--
>>   drivers/net/wireless/rsi/rsi_91x_main.c     |  4 +--
>>   drivers/net/wireless/rsi/rsi_91x_sdio.c     | 39 ++++++++-------------
>>   drivers/net/wireless/rsi/rsi_91x_sdio_ops.c | 15 +++-----
>>   drivers/net/wireless/rsi/rsi_91x_usb.c      | 20 +++++------
>>   drivers/net/wireless/rsi/rsi_91x_usb_ops.c  |  2 +-
>>   9 files changed, 40 insertions(+), 60 deletions(-)
>>
>> --
>> 2.30.2
>>
>>
