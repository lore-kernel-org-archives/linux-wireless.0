Return-Path: <SRS0=tM6R=XW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD6CAC4360C
	for <linux-wireless@archiver.kernel.org>; Fri, 27 Sep 2019 07:09:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AED712146E
	for <linux-wireless@archiver.kernel.org>; Fri, 27 Sep 2019 07:09:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbfI0HI5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 27 Sep 2019 03:08:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56706 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbfI0HI4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Sep 2019 03:08:56 -0400
Received: from localhost (unknown [65.39.69.237])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 23C9D14CDFE0B;
        Fri, 27 Sep 2019 00:08:53 -0700 (PDT)
Date:   Fri, 27 Sep 2019 09:08:18 +0200 (CEST)
Message-Id: <20190927.090818.895436971537381028.davem@davemloft.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull-request: wireless-drivers 2019-09-26
From:   David Miller <davem@davemloft.net>
In-Reply-To: <8736gj5i6a.fsf@kamboji.qca.qualcomm.com>
References: <8736gj5i6a.fsf@kamboji.qca.qualcomm.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Sep 2019 00:08:55 -0700 (PDT)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Kalle Valo <kvalo@codeaurora.org>
Date: Thu, 26 Sep 2019 15:57:33 +0300

> here's a pull request to net tree for v5.4. Please let me know if there
> are any problems.

Pulled, thanks Kalle.
