Return-Path: <SRS0=K8Xh=QX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86314C43381
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Feb 2019 03:43:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5BF5F222D0
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Feb 2019 03:43:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729038AbfBPDm6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 22:42:58 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49090 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbfBPDm6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 22:42:58 -0500
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::bf5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1E36C14F15C28;
        Fri, 15 Feb 2019 19:42:57 -0800 (PST)
Date:   Fri, 15 Feb 2019 19:42:54 -0800 (PST)
Message-Id: <20190215.194254.160143313358698905.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2019-02-15
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190215125146.18856-1-johannes@sipsolutions.net>
References: <20190215125146.18856-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 15 Feb 2019 19:42:57 -0800 (PST)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 15 Feb 2019 13:51:45 +0100

> It's clear things are winding down, this is basically just the stuff
> from Herbert that we've been discussing. I threw in a simple error
> path fix, mostly because it's simple :-)
> 
> Please pull and let me know if there's any problem.

Ok, pulled, thanks Johannes.
