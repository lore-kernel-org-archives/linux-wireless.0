Return-Path: <SRS0=x8ok=SU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6EB6C10F0E
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 18:14:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81D06206B6
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 18:14:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391917AbfDRSOr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Apr 2019 14:14:47 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43672 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391146AbfDRSOr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Apr 2019 14:14:47 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 836331478DBFD;
        Thu, 18 Apr 2019 11:14:46 -0700 (PDT)
Date:   Thu, 18 Apr 2019 11:14:44 -0700 (PDT)
Message-Id: <20190418.111444.1325343486196462539.davem@davemloft.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next 2019-04-18
From:   David Miller <davem@davemloft.net>
In-Reply-To: <87sguf2zmj.fsf@kamboji.qca.qualcomm.com>
References: <87sguf2zmj.fsf@kamboji.qca.qualcomm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Apr 2019 11:14:46 -0700 (PDT)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Kalle Valo <kvalo@codeaurora.org>
Date: Thu, 18 Apr 2019 16:48:20 +0300

> here's a pull request to net-next for v5.2, more info below. But do note
> that this time we have two trivial conflicts in iwlwifi, here are
> Stephen's example resolutions:
> 
> https://lkml.kernel.org/r/20190415120133.40c0f343@canb.auug.org.au
> 
> https://lkml.kernel.org/r/20190415120853.39e0e46a@canb.auug.org.au
> 
> The only change to Stephen's resolution I recommend is to have in drv.c
> an empty line between group 0x2723 and group 0x1a56, but that's just
> cosmetic anyway so it doesn't matter really in the end.
> 
> As always, please do let me know if there any problems.

Pulled, please double check my work.
