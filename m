Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 952BCC43219
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 16:07:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DB26208E4
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 16:07:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbfDZQHv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 12:07:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38434 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbfDZQHu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 12:07:50 -0400
Received: from localhost (unknown [12.154.31.190])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B0BC514696BB2;
        Fri, 26 Apr 2019 09:07:49 -0700 (PDT)
Date:   Fri, 26 Apr 2019 12:07:47 -0400 (EDT)
Message-Id: <20190426.120747.1538732968291927600.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     sameo@linux.intel.com, daniel@zonque.org, dagmcr@gmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH -next] NFC: st95hf: remove set but not used variables
 'dev, nfcddev'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190425020720.46560-1-yuehaibing@huawei.com>
References: <20190425020720.46560-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 26 Apr 2019 09:07:50 -0700 (PDT)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Thu, 25 Apr 2019 02:07:20 +0000

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/nfc/st95hf/core.c: In function 'st95hf_irq_thread_handler':
> drivers/nfc/st95hf/core.c:786:26: warning:
>  variable 'nfcddev' set but not used [-Wunused-but-set-variable]
> 
> drivers/nfc/st95hf/core.c:784:17: warning:
>  variable 'dev' set but not used [-Wunused-but-set-variable]
> 
> They are never used since introduction in
> commit cab47333f0f7 ("NFC: Add STMicroelectronics ST95HF driver")
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied, thank you.
