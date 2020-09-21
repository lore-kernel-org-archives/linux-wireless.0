Return-Path: <SRS0=BG2g=C6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECCCEC4727E
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Sep 2020 21:55:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C072E20709
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Sep 2020 21:55:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728251AbgIUVzd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Sep 2020 17:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726497AbgIUVzd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Sep 2020 17:55:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A5FAC061755;
        Mon, 21 Sep 2020 14:55:33 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AA68A11E49F62;
        Mon, 21 Sep 2020 14:38:45 -0700 (PDT)
Date:   Mon, 21 Sep 2020 14:55:32 -0700 (PDT)
Message-Id: <20200921.145532.2113926694890361909.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2020-09-21
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200921132241.25883-1-johannes@sipsolutions.net>
References: <20200921132241.25883-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 21 Sep 2020 14:38:45 -0700 (PDT)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Mon, 21 Sep 2020 15:22:40 +0200

> We have a few more fixes for 5.9, see below.
> 
> Please pull and let me know if there's any problem.

Pulled, thank you.
