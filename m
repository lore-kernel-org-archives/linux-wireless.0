Return-Path: <SRS0=82ey=XA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98D8FC43331
	for <linux-wireless@archiver.kernel.org>; Thu,  5 Sep 2019 14:16:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 745F521924
	for <linux-wireless@archiver.kernel.org>; Thu,  5 Sep 2019 14:10:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729134AbfIEOKr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 5 Sep 2019 10:10:47 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:6231 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727914AbfIEOKr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Sep 2019 10:10:47 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 0FE5E5BA7995343B8379;
        Thu,  5 Sep 2019 22:10:45 +0800 (CST)
Received: from [127.0.0.1] (10.177.29.68) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Thu, 5 Sep 2019
 22:10:41 +0800
Message-ID: <5D711760.20903@huawei.com>
Date:   Thu, 5 Sep 2019 22:10:40 +0800
From:   zhong jiang <zhongjiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hostap: remove set but not used variable 'copied' in
 prism2_io_debug_proc_read
References: <1567497430-22539-1-git-send-email-zhongjiang@huawei.com> <5D6E1DF2.1000109@huawei.com> <87zhjij1q6.fsf@tynnyri.adurom.net>
In-Reply-To: <87zhjij1q6.fsf@tynnyri.adurom.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.29.68]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019/9/5 21:45, Kalle Valo wrote:
> zhong jiang <zhongjiang@huawei.com> writes:
>
>> Please ignore the patch.  Because  the hostap_proc.c is marked as 'obsolete'.
> You mean marked in the MAINTAINERS file? I don't see that as a problem,
> I can (and should) still apply any patches submitted to hostap driver.
>
I  hit the following issue when checking the patch by checkpatch.pl

WARNING: drivers/net/wireless/intersil/hostap/hostap_proc.c is marked as 'obsolete' in the MAINTAINERS hierarchy.
No unnecessary modifications please.

I certainly hope it can be appiled to upstream if the above check doesn't matter.

Thanks,
zhong jiang

