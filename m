Return-Path: <SRS0=iVws=XB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13C4AC43331
	for <linux-wireless@archiver.kernel.org>; Fri,  6 Sep 2019 13:22:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8438206BB
	for <linux-wireless@archiver.kernel.org>; Fri,  6 Sep 2019 13:22:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393274AbfIFNWM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 6 Sep 2019 09:22:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60074 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728793AbfIFNWL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Sep 2019 09:22:11 -0400
Received: from localhost (unknown [88.214.184.128])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9D4FF152F9952;
        Fri,  6 Sep 2019 06:22:10 -0700 (PDT)
Date:   Fri, 06 Sep 2019 15:22:09 +0200 (CEST)
Message-Id: <20190906.152209.944704898049442468.davem@davemloft.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull-request: wireless-drivers 2019-09-05
From:   David Miller <davem@davemloft.net>
In-Reply-To: <87k1amluae.fsf@kamboji.qca.qualcomm.com>
References: <87k1amluae.fsf@kamboji.qca.qualcomm.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 06 Sep 2019 06:22:11 -0700 (PDT)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Kalle Valo <kvalo@codeaurora.org>
Date: Thu, 05 Sep 2019 16:58:01 +0300

> here's a pull request to net tree for v5.3, more info below. Please let
> me know if there are any problems.

Pulled, thanks Kalle.
