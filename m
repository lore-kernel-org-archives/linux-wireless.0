Return-Path: <SRS0=qpxp=O4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD843C43387
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 16:39:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85E30217D9
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 16:39:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729447AbeLSQjq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 19 Dec 2018 11:39:46 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:60868 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727602AbeLSQjq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Dec 2018 11:39:46 -0500
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::cf9])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8C6FF14E242EB;
        Wed, 19 Dec 2018 08:39:45 -0800 (PST)
Date:   Wed, 19 Dec 2018 08:39:44 -0800 (PST)
Message-Id: <20181219.083944.105677597313890602.davem@davemloft.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull-request: wireless-drivers 2018-12-19
From:   David Miller <davem@davemloft.net>
In-Reply-To: <87bm5hvb51.fsf@kamboji.qca.qualcomm.com>
References: <87bm5hvb51.fsf@kamboji.qca.qualcomm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Dec 2018 08:39:45 -0800 (PST)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Kalle Valo <kvalo@codeaurora.org>
Date: Wed, 19 Dec 2018 16:34:02 +0200

> this a pull request to net tree for 4.20, more info below.
> 
> Really sorry for sending a late request like this but I have been busy
> with other stuff and this just got delayed. These are pretty
> important fixes so I hope there's still time to get them to 4.20. But if
> there's not time, please let me know and I'll pull these to
> wireless-drivers-next.
> 
> All of these, expect the ath10k fix, have been in linux-next, and even
> the ath10k fix was in the pending branch so it has been tested by the
> kbuild bot.
> 
> I'll send the -next pull request tomorrow. Please let me know if there
> are any problems.

No problem, pulled, thanks!
