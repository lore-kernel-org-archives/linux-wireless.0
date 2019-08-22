Return-Path: <SRS0=699K=WS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EA64C3A5A1
	for <linux-wireless@archiver.kernel.org>; Thu, 22 Aug 2019 23:12:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B0002173E
	for <linux-wireless@archiver.kernel.org>; Thu, 22 Aug 2019 23:12:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390656AbfHVXMi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 22 Aug 2019 19:12:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50362 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732378AbfHVXMi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Aug 2019 19:12:38 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C975A1539AF08;
        Thu, 22 Aug 2019 16:12:37 -0700 (PDT)
Date:   Thu, 22 Aug 2019 16:12:37 -0700 (PDT)
Message-Id: <20190822.161237.59235267978130262.davem@davemloft.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: pull-request: wireless-drivers 2019-08-21
From:   David Miller <davem@davemloft.net>
In-Reply-To: <87zhk359wd.fsf@kamboji.qca.qualcomm.com>
References: <87zhk359wd.fsf@kamboji.qca.qualcomm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 22 Aug 2019 16:12:38 -0700 (PDT)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Kalle Valo <kvalo@codeaurora.org>
Date: Wed, 21 Aug 2019 09:07:30 +0300

> here's a pull request to net for 5.3, more info below. I will be offline
> the next week, but Johannes should be able to help if there are any
> issues.

Pulled, thanks Kalle.
