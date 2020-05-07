Return-Path: <SRS0=9CG8=6V=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB815C4724C
	for <linux-wireless@archiver.kernel.org>; Thu,  7 May 2020 20:23:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB00924959
	for <linux-wireless@archiver.kernel.org>; Thu,  7 May 2020 20:23:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728474AbgEGUXI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 May 2020 16:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726558AbgEGUXH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 May 2020 16:23:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB7A4C05BD43;
        Thu,  7 May 2020 13:23:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9E66C1195051C;
        Thu,  7 May 2020 13:23:07 -0700 (PDT)
Date:   Thu, 07 May 2020 13:23:07 -0700 (PDT)
Message-Id: <20200507.132307.1830841066147755945.davem@davemloft.net>
To:     kvalo@codeaurora.org
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next-2020-05-07
From:   David Miller <davem@davemloft.net>
In-Reply-To: <87sggb7uf1.fsf@kamboji.qca.qualcomm.com>
References: <87sggb7uf1.fsf@kamboji.qca.qualcomm.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 May 2020 13:23:07 -0700 (PDT)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Kalle Valo <kvalo@codeaurora.org>
Date: Thu, 07 May 2020 16:21:06 +0300

> here's a pull request to net-next tree, more info below. Please let me know if
> there are any problems.

Pulled, thanks Kalle.
