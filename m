Return-Path: <SRS0=hbYo=M5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEC9BECDE32
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 07:48:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92485214C3
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 07:48:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 92485214C3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727299AbeJQPmr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Oct 2018 11:42:47 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56483 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726947AbeJQPmr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Oct 2018 11:42:47 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 267C1C061558E;
        Wed, 17 Oct 2018 15:48:19 +0800 (CST)
Received: from [127.0.0.1] (10.177.31.96) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.399.0; Wed, 17 Oct 2018
 15:48:16 +0800
Subject: Re: [PATCH] iwlwifi: acpi: Use kmemdup rather than duplicating its
 implementation in iwl_parse_nvm_mcc_info
To:     Luciano Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <1538730169-145458-1-git-send-email-yuehaibing@huawei.com>
 <4016573ae1c44a37bbf98c1225c02afd8b82e713.camel@intel.com>
CC:     <linux-wireless@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <a3ce52c5-c3d8-a06e-6f97-6b40d2906e4a@huawei.com>
Date:   Wed, 17 Oct 2018 15:48:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <4016573ae1c44a37bbf98c1225c02afd8b82e713.camel@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On 2018/10/17 15:25, Luciano Coelho wrote:
> On Fri, 2018-10-05 at 09:02 +0000, YueHaibing wrote:
>> Use kmemdup rather than duplicating its implementation
>>
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>> ---
> 
> Thanks, YueHaibing.  I have applied this in our internal tree and it
> will eventually reach the mainline, following our normal upstreaming
> process.
> 
> I have modified the subject and the commit message a bit.

Thanks you!

> 
> --
> Cheers,
> Luca.
> 
> 
> .
> 

