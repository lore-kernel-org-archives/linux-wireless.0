Return-Path: <SRS0=XcSR=XC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 456B8C43331
	for <linux-wireless@archiver.kernel.org>; Sat,  7 Sep 2019 08:35:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2860F2186A
	for <linux-wireless@archiver.kernel.org>; Sat,  7 Sep 2019 08:35:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405851AbfIGIe2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 7 Sep 2019 04:34:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42546 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbfIGIe1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 7 Sep 2019 04:34:27 -0400
Received: from localhost (unknown [88.214.184.0])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 536A314C63FEE;
        Sat,  7 Sep 2019 01:34:26 -0700 (PDT)
Date:   Sat, 07 Sep 2019 10:34:22 +0200 (CEST)
Message-Id: <20190907.103422.1484798668061334498.davem@davemloft.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next 2019-09-07
From:   David Miller <davem@davemloft.net>
In-Reply-To: <87blvwlelw.fsf@kamboji.qca.qualcomm.com>
References: <87blvwlelw.fsf@kamboji.qca.qualcomm.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 07 Sep 2019 01:34:27 -0700 (PDT)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Kalle Valo <kvalo@codeaurora.org>
Date: Sat, 07 Sep 2019 11:01:15 +0300

> here's a pull request to net-next for v5.4, more info below. Please let
> me know if there are any problems.

Pulled, thanks Kalle.
