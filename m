Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D8B7C4151A
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 07:04:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24283217F5
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 07:04:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725770AbfA2HEa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 02:04:30 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54428 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbfA2HEa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 02:04:30 -0500
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::bf5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9C8F01403ED29;
        Mon, 28 Jan 2019 23:04:29 -0800 (PST)
Date:   Mon, 28 Jan 2019 23:04:29 -0800 (PST)
Message-Id: <20190128.230429.817350133799784337.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH net-next] net: nci: remove set-but-not-used variable
 'status'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190129064028.7768-1-yuehaibing@huawei.com>
References: <20190129064028.7768-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 28 Jan 2019 23:04:29 -0800 (PST)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Tue, 29 Jan 2019 14:40:28 +0800

> gcc warning this:
> net/nfc/nci/hci.c:373:5:
>  warning: variable 'status' set but not used [-Wunused-but-set-variable]
> 
> It not used since commit d8cd37ed2fc8 ("NFC: nci: Fix improper
> management of HCI return code"), so can be removed.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

I'll let the wireless/nfc folks pick this up.
