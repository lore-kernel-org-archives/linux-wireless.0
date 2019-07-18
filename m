Return-Path: <SRS0=/Ln1=VP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8CF5C76195
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Jul 2019 19:00:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A91EA2173B
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Jul 2019 19:00:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391011AbfGRTAk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Jul 2019 15:00:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54260 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727742AbfGRTAj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Jul 2019 15:00:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5935C1527D7FB;
        Thu, 18 Jul 2019 12:00:39 -0700 (PDT)
Date:   Thu, 18 Jul 2019 12:00:38 -0700 (PDT)
Message-Id: <20190718.120038.732161301700227801.davem@davemloft.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull-request: wireless-drivers 2019-07-18
From:   David Miller <davem@davemloft.net>
In-Reply-To: <87y30v1lub.fsf@kamboji.qca.qualcomm.com>
References: <87y30v1lub.fsf@kamboji.qca.qualcomm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Jul 2019 12:00:39 -0700 (PDT)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Kalle Valo <kvalo@codeaurora.org>
Date: Thu, 18 Jul 2019 17:03:24 +0300

> here are first fixes which have accumulated during the merge window.
> This pull request is to net tree for 5.3. Please let me know if there
> are any problems.

Pulled, thanks Kalle.
