Return-Path: <SRS0=LItA=3E=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2463C33CB1
	for <linux-wireless@archiver.kernel.org>; Wed, 15 Jan 2020 12:19:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F53C207FF
	for <linux-wireless@archiver.kernel.org>; Wed, 15 Jan 2020 12:19:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730547AbgAOMMf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 15 Jan 2020 07:12:35 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54984 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730407AbgAOMMe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Jan 2020 07:12:34 -0500
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5DB96159D139C;
        Wed, 15 Jan 2020 04:12:32 -0800 (PST)
Date:   Wed, 15 Jan 2020 04:12:27 -0800 (PST)
Message-Id: <20200115.041227.1501138300501649995.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2020-01-15
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200115100333.40963-1-johannes@sipsolutions.net>
References: <20200115100333.40963-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 15 Jan 2020 04:12:33 -0800 (PST)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Wed, 15 Jan 2020 11:03:32 +0100

> Here's a small set of fixes for the current cycle still. Most
> issues are actually older and tagged with appropriate Fixes
> etc.
> 
> Please pull and let me know if there's any problem.

Pulled, thanks Johannes.
