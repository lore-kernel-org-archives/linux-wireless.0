Return-Path: <SRS0=rxFU=5K=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC526C2D0E6
	for <linux-wireless@archiver.kernel.org>; Wed, 25 Mar 2020 20:12:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE11320719
	for <linux-wireless@archiver.kernel.org>; Wed, 25 Mar 2020 20:12:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbgCYUMy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 25 Mar 2020 16:12:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47154 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbgCYUMy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Mar 2020 16:12:54 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D4BC615A0D3B6;
        Wed, 25 Mar 2020 13:12:53 -0700 (PDT)
Date:   Wed, 25 Mar 2020 13:12:50 -0700 (PDT)
Message-Id: <20200325.131250.822565965107597577.davem@davemloft.net>
To:     kvalo@codeaurora.org
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-2020-03-25
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200325195754.92C97C433D2@smtp.codeaurora.org>
References: <20200325195754.92C97C433D2@smtp.codeaurora.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 25 Mar 2020 13:12:54 -0700 (PDT)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Kalle Valo <kvalo@codeaurora.org>
Date: Wed, 25 Mar 2020 19:57:54 +0000 (UTC)

> here's a pull request to net tree, more info below. Please let me know if there
> are any problems.

Pulled, thanks Kalle.
