Return-Path: <SRS0=ULv+=XM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B637DC4CECE
	for <linux-wireless@archiver.kernel.org>; Tue, 17 Sep 2019 13:37:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98041206C2
	for <linux-wireless@archiver.kernel.org>; Tue, 17 Sep 2019 13:37:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728481AbfIQNhJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 17 Sep 2019 09:37:09 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:53122 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727930AbfIQNhJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Sep 2019 09:37:09 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 18446C2E2417DE0954E7;
        Tue, 17 Sep 2019 21:37:07 +0800 (CST)
Received: from [127.0.0.1] (10.177.29.68) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Tue, 17 Sep 2019
 21:37:02 +0800
Message-ID: <5D80E17D.2000800@huawei.com>
Date:   Tue, 17 Sep 2019 21:37:01 +0800
From:   zhong jiang <zhongjiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     <davem@davemloft.net>, <ath10k@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Use ARRAY_SIZE instead of dividing sizeof array
 with sizeof an element
References: <1567582878-18739-1-git-send-email-zhongjiang@huawei.com> <20190917071632.001AC6155E@smtp.codeaurora.org>
In-Reply-To: <20190917071632.001AC6155E@smtp.codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.29.68]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019/9/17 15:16, Kalle Valo wrote:
> zhong jiang <zhongjiang@huawei.com> wrote:
>
>> With the help of Coccinelle, ARRAY_SIZE can be replaced in ath10k_snoc_wlan_enable.
>>
>> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
> I already got an identical patch so dropping this one.
>
> error: patch failed: drivers/net/wireless/ath/ath10k/snoc.c:976
> error: drivers/net/wireless/ath/ath10k/snoc.c: patch does not apply
> stg import: Diff does not apply cleanly
>
Thank for your remainder.

Sincerely,
zhong jiang

