Return-Path: <SRS0=F8Dj=QZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F620C4360F
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 14:23:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A0F021901
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 14:23:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390410AbfBROXW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 09:23:22 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:3773 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388517AbfBROEk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 09:04:40 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 9F2624CB6C96CEAF0899;
        Mon, 18 Feb 2019 22:04:36 +0800 (CST)
Received: from [127.0.0.1] (10.177.96.96) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.408.0; Mon, 18 Feb 2019
 22:04:36 +0800
Subject: Re: [PATCH net-next] cfg80211: pmsr: use eth_broadcast_addr() to
 assign broadcast address
To:     Kalle Valo <kvalo@codeaurora.org>
References: <20190216094710.127182-1-maowenan@huawei.com>
 <927ff17c-c506-734f-fc27-796d4c8fba98@huawei.com>
 <878sydus0p.fsf@kamboji.qca.qualcomm.com>
CC:     <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, <netdev@vger.kernel.org>
From:   maowenan <maowenan@huawei.com>
Message-ID: <25eb542b-8052-86bc-f633-630289f5036a@huawei.com>
Date:   Mon, 18 Feb 2019 22:04:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <878sydus0p.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.96.96]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On 2019/2/18 21:48, Kalle Valo wrote:
> maowenan <maowenan@huawei.com> writes:
> 
>> Add kalle Valo in mail list.
>>
>> Hi Kalle Valo,
>> Do you have any comments about this patch?
> 
> Why do you ask me? Johannes maintains cfg80211, not me, and he will
> provide comments once he reviews the patch (which might take some time,
> we do have other tasks as well).

I'm sorry for this, my mistake to add wrong maintainer.

> 

