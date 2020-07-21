Return-Path: <SRS0=5LI1=BA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0C75C433E0
	for <linux-wireless@archiver.kernel.org>; Tue, 21 Jul 2020 00:53:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCBB62080D
	for <linux-wireless@archiver.kernel.org>; Tue, 21 Jul 2020 00:53:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgGUAxV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 20 Jul 2020 20:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbgGUAxU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Jul 2020 20:53:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC54FC0619D6;
        Mon, 20 Jul 2020 17:53:20 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8975B11E8EC30;
        Mon, 20 Jul 2020 17:36:35 -0700 (PDT)
Date:   Mon, 20 Jul 2020 17:53:19 -0700 (PDT)
Message-Id: <20200720.175319.829442407570465216.davem@davemloft.net>
nTo:    kvalo@codeaurora.org
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next-2020-07-20
From:   David Miller <davem@davemloft.net>
In-Reply-To: <875zai6xfl.fsf@codeaurora.org>
References: <875zai6xfl.fsf@codeaurora.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Jul 2020 17:36:35 -0700 (PDT)
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Kalle Valo <kvalo@codeaurora.org>
Date: Mon, 20 Jul 2020 18:03:26 +0300

> here's a pull request to net-next tree, more info below. Please let me know if
> there are any problems.
> 
> Kalle
> 
> The following changes since commit b3a9e3b9622ae10064826dccb4f7a52bd88c7407:
> 
>   Linux 5.8-rc1 (2020-06-14 12:45:04 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-2020-07-20

Pulled, thank you.
