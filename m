Return-Path: <SRS0=D8BG=56=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11FCDC352BE
	for <linux-wireless@archiver.kernel.org>; Tue, 14 Apr 2020 20:13:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFB4F2076B
	for <linux-wireless@archiver.kernel.org>; Tue, 14 Apr 2020 20:13:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632764AbgDNUMz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 14 Apr 2020 16:12:55 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33766 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2632761AbgDNUMS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Apr 2020 16:12:18 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6A1A4127FD184;
        Tue, 14 Apr 2020 13:12:14 -0700 (PDT)
Date:   Tue, 14 Apr 2020 13:12:09 -0700 (PDT)
Message-Id: <20200414.131209.1108253082504989993.davem@davemloft.net>
To:     kvalo@codeaurora.org
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-2020-04-14
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200414153500.E59C9C432C2@smtp.codeaurora.org>
References: <20200414153500.E59C9C432C2@smtp.codeaurora.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Apr 2020 13:12:14 -0700 (PDT)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Kalle Valo <kvalo@codeaurora.org>
Date: Tue, 14 Apr 2020 15:35:00 +0000 (UTC)

> here's a pull request to net tree, more info below. Please let me know if there
> are any problems.

Pulled, thanks Kalle.
