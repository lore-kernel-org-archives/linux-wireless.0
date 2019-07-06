Return-Path: <SRS0=YRAg=VD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F5E0C0650E
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Jul 2019 22:20:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B71820836
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Jul 2019 22:20:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbfGFWUQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Jul 2019 18:20:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58294 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbfGFWUQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Jul 2019 18:20:16 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C724B151CBED1;
        Sat,  6 Jul 2019 15:20:15 -0700 (PDT)
Date:   Sat, 06 Jul 2019 15:20:15 -0700 (PDT)
Message-Id: <20190706.152015.1057462647339887923.davem@davemloft.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next 2019-07-06
From:   David Miller <davem@davemloft.net>
In-Reply-To: <878stbabkb.fsf@kamboji.qca.qualcomm.com>
References: <878stbabkb.fsf@kamboji.qca.qualcomm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 06 Jul 2019 15:20:15 -0700 (PDT)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Kalle Valo <kvalo@codeaurora.org>
Date: Sat, 06 Jul 2019 10:04:20 +0300

> here's a pull request to net-next tree for v5.3, more info below. I will
> be offline from Sunday to Thursday, but Johannes should be able to help
> during that time.

Pulled, thanks Kalle.
