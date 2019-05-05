Return-Path: <SRS0=ua54=TF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B6C5C04AAC
	for <linux-wireless@archiver.kernel.org>; Sun,  5 May 2019 17:22:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76AC4205F4
	for <linux-wireless@archiver.kernel.org>; Sun,  5 May 2019 17:22:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727694AbfEERV4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 5 May 2019 13:21:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52780 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727325AbfEERV4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 5 May 2019 13:21:56 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E00EF14DA0307;
        Sun,  5 May 2019 10:21:54 -0700 (PDT)
Date:   Sun, 05 May 2019 10:21:54 -0700 (PDT)
Message-Id: <20190505.102154.2079817625143467430.davem@davemloft.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next 2019-05-03
From:   David Miller <davem@davemloft.net>
In-Reply-To: <87bm0jk9tv.fsf@kamboji.qca.qualcomm.com>
References: <87bm0jk9tv.fsf@kamboji.qca.qualcomm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 May 2019 10:21:55 -0700 (PDT)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Kalle Valo <kvalo@codeaurora.org>
Date: Fri, 03 May 2019 15:21:16 +0300

> here's a pull request to net-next for 5.2, more information below. Also
> there's a conflict in iwlwifi again and this time I added the conflict
> resolution to the signed tag based on our discussion earlier this week.
> Please let me know what you think or there are any problems.

Pulled, looks great, thanks Kalle.
