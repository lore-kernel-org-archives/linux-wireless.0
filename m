Return-Path: <SRS0=KFxB=X2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A53B5C352AA
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Oct 2019 16:29:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8649421855
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Oct 2019 16:29:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389963AbfJAQ3V (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 1 Oct 2019 12:29:21 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49332 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbfJAQ3V (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Oct 2019 12:29:21 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A3353154B74E9;
        Tue,  1 Oct 2019 09:29:20 -0700 (PDT)
Date:   Tue, 01 Oct 2019 09:29:20 -0700 (PDT)
Message-Id: <20191001.092920.502666999762381001.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2019-10-01
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191001160117.13628-1-johannes@sipsolutions.net>
References: <20191001160117.13628-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 01 Oct 2019 09:29:20 -0700 (PDT)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue,  1 Oct 2019 18:01:16 +0200

> Here's a list of fixes - the BHs disabled one has been reported
> multiple times, and the SSID/MBSSID ordering one has over-the-air
> security implementations.
> 
> Please pull and let me know if there's any problem.

Pulled and build testing, thanks Johannes.
