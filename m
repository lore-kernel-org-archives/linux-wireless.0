Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1767AC282DA
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 18:21:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3CD121726
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 18:21:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730668AbfBASVi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 13:21:38 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47676 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729451AbfBASVi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 13:21:38 -0500
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::bf5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 71ABE14283DCF;
        Fri,  1 Feb 2019 10:21:37 -0800 (PST)
Date:   Fri, 01 Feb 2019 10:21:36 -0800 (PST)
Message-Id: <20190201.102136.1888365356474793941.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2019-02-01
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190201111651.10203-1-johannes@sipsolutions.net>
References: <20190201111651.10203-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 01 Feb 2019 10:21:37 -0800 (PST)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri,  1 Feb 2019 12:16:50 +0100

> Here's my next pull request for net-next. I wanted to include more,
> notably the multi-BSSID work that's going on now (multi-BSSID lets
> a single AP with a single beacon have multiple networks, rather than
> requiring a beacon for each), but we're still finding small issues
> and bugs in it, so I haven't included it. As always, I'll send it
> when it's ready :-)

Ok.

> As noted below, this contains the NLA_POLICY_NESTED{,_ARRAY} changes
> I showed you earlier, no new users have been added to net-next as
> of today when I merged your tree to mine (to get the net changes to
> not have conflicts over this in wireless code.)

Thanks for all of this information, it really helps me audit and
understand a pull request better.

> Please pull and let me know if there's any problem.

Pulled, thanks Johannes.
