Return-Path: <SRS0=pXXP=BO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01E3FC433DF
	for <linux-wireless@archiver.kernel.org>; Tue,  4 Aug 2020 19:58:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2ED221744
	for <linux-wireless@archiver.kernel.org>; Tue,  4 Aug 2020 19:58:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbgHDT6I (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 4 Aug 2020 15:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726824AbgHDT6I (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Aug 2020 15:58:08 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C20C0C06174A;
        Tue,  4 Aug 2020 12:58:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F083112880A37;
        Tue,  4 Aug 2020 12:41:21 -0700 (PDT)
Date:   Tue, 04 Aug 2020 12:58:06 -0700 (PDT)
Message-Id: <20200804.125806.1796616541997080836.davem@davemloft.net>
To:     kvalo@codeaurora.org
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next-2020-08-04
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200804111433.93586C433CA@smtp.codeaurora.org>
References: <20200804111433.93586C433CA@smtp.codeaurora.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Aug 2020 12:41:22 -0700 (PDT)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Kalle Valo <kvalo@codeaurora.org>
Date: Tue,  4 Aug 2020 11:14:33 +0000 (UTC)

> wireless-drivers-next patches for v5.9
> 
> Second set of patches for v5.9. mt76 has most of patches this time.
> Otherwise it's just smaller fixes and cleanups to other drivers.
> 
> There was a major conflict in mt76 driver between wireless-drivers and
> wireless-drivers-next. I solved that by merging the former to the
> latter.
 ...

Pulled, thanks Kalle.

I don't know how I missed the conflict resolution guide in your previous
pull request.  I was sure I scanned it for such info several times :-/

Thanks again!
