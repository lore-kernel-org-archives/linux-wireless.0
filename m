Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FCB0C10F00
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 20:53:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36648206B6
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 20:53:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbfBVUw6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 15:52:58 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57958 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbfBVUwy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 15:52:54 -0500
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::bf5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D4E9D14AA9F1E;
        Fri, 22 Feb 2019 12:52:53 -0800 (PST)
Date:   Fri, 22 Feb 2019 12:52:53 -0800 (PST)
Message-Id: <20190222.125253.538976775741256961.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2019-02-22
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190222132513.29834-1-johannes@sipsolutions.net>
References: <20190222132513.29834-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 Feb 2019 12:52:54 -0800 (PST)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 22 Feb 2019 14:25:12 +0100

> Here's the promised update with the big multi-BSSID changes,
> which are related to HE (802.11ax) for which we also have some
> updates.
> 
> Note that I took the liberty of including Herbert's rhashtable
> API removal, I merged net-next for that and verified that the
> API he removed is also not used in anything new, but if you
> apply/applied any patches after I pulled you should probably
> double check that again.
> 
> Please pull and let me know if there's any problem.

Pulled, looks good on this end.

Will push back out after build testing.

Thanks!
