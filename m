Return-Path: <SRS0=qpxp=O4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05B91C43387
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 16:36:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D11C7218A6
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 16:36:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728831AbeLSQgv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 19 Dec 2018 11:36:51 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:60828 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728282AbeLSQgv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Dec 2018 11:36:51 -0500
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::cf9])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8D85A14E2221C;
        Wed, 19 Dec 2018 08:36:50 -0800 (PST)
Date:   Wed, 19 Dec 2018 08:36:50 -0800 (PST)
Message-Id: <20181219.083650.1968125050742844549.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2018-12-19
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20181219093034.11602-1-johannes@sipsolutions.net>
References: <20181219093034.11602-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Dec 2018 08:36:50 -0800 (PST)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Wed, 19 Dec 2018 10:30:33 +0100

> Last chance, I guess, but do have quite a long list of
> changes for -next, some of which I really should've
> sent earlier, sorry about that. See below for a brief
> summary in the tag, and of course the shortlog is also
> below.
> 
> The biggest (code-wise) things are the virt_wifi for
> pretending to have wifi control on another network
> connection, and the peer measurement APIs for FTM
> (flight time measurement, wifi location).
> 
> FWIW, this includes the nl_set_extack_cookie_u64()
> I had sent previously, the peer measurement APIs now
> finally use it.
> 
> Please pull and let me know if there's any problem.

Looks great, pulled, thanks!
