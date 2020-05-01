Return-Path: <SRS0=VQ8Y=6P=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F331AC4724C
	for <linux-wireless@archiver.kernel.org>; Fri,  1 May 2020 00:52:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD4F3206C0
	for <linux-wireless@archiver.kernel.org>; Fri,  1 May 2020 00:52:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbgEAAwP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 30 Apr 2020 20:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727884AbgEAAwO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Apr 2020 20:52:14 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A97C035494;
        Thu, 30 Apr 2020 17:52:14 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 81128127437AF;
        Thu, 30 Apr 2020 17:52:14 -0700 (PDT)
Date:   Thu, 30 Apr 2020 17:52:13 -0700 (PDT)
Message-Id: <20200430.175213.101047596188117080.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, a@unstable.cc,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 0/8] netlink validation improvements/refactoring
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200430201312.60143-1-johannes@sipsolutions.net>
References: <20200430201312.60143-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Apr 2020 17:52:14 -0700 (PDT)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Thu, 30 Apr 2020 22:13:04 +0200

> Alright, this is the resend now, really just changing
> 
>  - the WARN_ON_ONCE() as spotted by Jakub;
>  - mark the export patch no longer RFC.
>    I wasn't actually sure if you meant this one too, and I really
>    should dig out and polish the code that showed it in userspace.

Honestly, I like this, so series applied.

Thanks Johannes.
