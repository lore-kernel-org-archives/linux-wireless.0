Return-Path: <SRS0=cMLu=Q2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1299C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 01:41:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A9402173C
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 01:41:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732924AbfBSBlX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 20:41:23 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57198 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732885AbfBSBlX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 20:41:23 -0500
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::bf5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8D26F108DE85D;
        Mon, 18 Feb 2019 17:41:22 -0800 (PST)
Date:   Mon, 18 Feb 2019 17:41:21 -0800 (PST)
Message-Id: <20190218.174121.1232425390470503854.davem@davemloft.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull-request: wireless-drivers 2019-02-18
From:   David Miller <davem@davemloft.net>
In-Reply-To: <87zhqtt98h.fsf@kamboji.qca.qualcomm.com>
References: <87zhqtt98h.fsf@kamboji.qca.qualcomm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 18 Feb 2019 17:41:22 -0800 (PST)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Kalle Valo <kvalo@codeaurora.org>
Date: Mon, 18 Feb 2019 17:19:26 +0200

> here's one more pull request to net tree for 5.0. Please let me know if
> you have any problems.

Pulled, thanks Kalle.
