Return-Path: <SRS0=X5Mf=YI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55357ECE588
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Oct 2019 16:41:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 363B920650
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Oct 2019 16:41:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbfJOQlg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Oct 2019 12:41:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36688 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbfJOQlg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Oct 2019 12:41:36 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:5314:1b70:2a53:887e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C3C3915035C82;
        Tue, 15 Oct 2019 09:41:35 -0700 (PDT)
Date:   Tue, 15 Oct 2019 12:41:31 -0400 (EDT)
Message-Id: <20191015.124131.1460380746118792831.davem@davemloft.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull-request: wireless-drivers 2019-10-15
From:   David Miller <davem@davemloft.net>
In-Reply-To: <87eezexkak.fsf@kamboji.qca.qualcomm.com>
References: <87eezexkak.fsf@kamboji.qca.qualcomm.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 15 Oct 2019 09:41:36 -0700 (PDT)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Kalle Valo <kvalo@codeaurora.org>
Date: Tue, 15 Oct 2019 15:30:59 +0300

> here's a pull request to net tree for v5.4, more info below. Please let
> me know if there are any problems.

Pulled, thanks Kalle.
