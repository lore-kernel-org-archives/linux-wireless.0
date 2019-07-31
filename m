Return-Path: <SRS0=Y9Fe=V4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44120C433FF
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Jul 2019 15:52:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2503C208E3
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Jul 2019 15:52:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728475AbfGaPwA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 31 Jul 2019 11:52:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39500 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfGaPwA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Jul 2019 11:52:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ED11B1401D374;
        Wed, 31 Jul 2019 08:51:59 -0700 (PDT)
Date:   Wed, 31 Jul 2019 08:51:59 -0700 (PDT)
Message-Id: <20190731.085159.1333596038120368490.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2019-07-31
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190731124933.19420-1-johannes@sipsolutions.net>
References: <20190731124933.19420-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 31 Jul 2019 08:52:00 -0700 (PDT)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Wed, 31 Jul 2019 14:49:32 +0200

> We have few fixes, most importantly probably the NETIF_F_LLTX revert,
> we thought we were now more layered like VLAN or such since we do all
> of the queue control internally, but it caused problems, evidently not.
> 
> Please pull and let me know if there's any problem.

Pulled, thanks Johannes.
