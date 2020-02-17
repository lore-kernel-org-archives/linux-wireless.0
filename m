Return-Path: <SRS0=IRMg=4F=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE7D7C7619C
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Feb 2020 03:00:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1F7B2086A
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Feb 2020 03:00:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgBQDAs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 16 Feb 2020 22:00:48 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48048 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbgBQDAs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Feb 2020 22:00:48 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2A391102C751B;
        Sun, 16 Feb 2020 19:00:48 -0800 (PST)
Date:   Sun, 16 Feb 2020 19:00:47 -0800 (PST)
Message-Id: <20200216.190047.2091611908583483304.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next next-2020-02-14
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200214111947.55727-1-johannes@sipsolutions.net>
References: <20200214111947.55727-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2020 19:00:48 -0800 (PST)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 14 Feb 2020 12:19:46 +0100

> And also for net-next, some updates. I have more in the
> queue, but want to get these in first, then forward my
> tree, and then get the others to avoid conflicts etc.
> 
> Please pull and let me know if there's any problem.

Pulled, thanks Johannes.
