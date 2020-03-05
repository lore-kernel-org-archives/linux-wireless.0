Return-Path: <SRS0=q56x=4W=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9863BC3F2D7
	for <linux-wireless@archiver.kernel.org>; Thu,  5 Mar 2020 23:06:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7557D20717
	for <linux-wireless@archiver.kernel.org>; Thu,  5 Mar 2020 23:06:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgCEXGA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 5 Mar 2020 18:06:00 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57460 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbgCEXF7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Mar 2020 18:05:59 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8FED615BF430A;
        Thu,  5 Mar 2020 15:05:59 -0800 (PST)
Date:   Thu, 05 Mar 2020 15:05:58 -0800 (PST)
Message-Id: <20200305.150558.1507247063970947267.davem@davemloft.net>
To:     kvalo@codeaurora.org
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-2020-03-05
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200305134603.734F2C433A2@smtp.codeaurora.org>
References: <20200305134603.734F2C433A2@smtp.codeaurora.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Mar 2020 15:05:59 -0800 (PST)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Kalle Valo <kvalo@codeaurora.org>
Date: Thu,  5 Mar 2020 13:46:03 +0000 (UTC)

> here's a pull request to net tree, more info below. Please let me know if there
> are any problems.

Pulled, thank you.
