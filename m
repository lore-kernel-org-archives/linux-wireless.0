Return-Path: <SRS0=eW0r=7W=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31EC7C433DF
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Jun 2020 00:14:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D0B42078D
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Jun 2020 00:14:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732711AbgFIAOv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Jun 2020 20:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731661AbgFIAOr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Jun 2020 20:14:47 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A3CC08C5C2;
        Mon,  8 Jun 2020 17:14:47 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A4C56128925D7;
        Mon,  8 Jun 2020 17:14:44 -0700 (PDT)
Date:   Mon, 08 Jun 2020 17:14:41 -0700 (PDT)
Message-Id: <20200608.171441.687021100254511315.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2020-06-08
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200608080834.11576-1-johannes@sipsolutions.net>
References: <20200608080834.11576-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 08 Jun 2020 17:14:44 -0700 (PDT)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Mon,  8 Jun 2020 10:08:32 +0200

> We have a couple of updates - most importantly the fix
> for the deadlock issue that came up.
> 
> Please pull and let me know if there's any problem.

Pulled, thanks Johannes.

