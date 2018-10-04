Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10A85C64EBC
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 20:48:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2A1A2083F
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 20:48:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C2A1A2083F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=davemloft.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727797AbeJEDnj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Oct 2018 23:43:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55838 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727536AbeJEDnj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Oct 2018 23:43:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1c06::4572])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 12515147E0085;
        Thu,  4 Oct 2018 13:48:39 -0700 (PDT)
Date:   Thu, 04 Oct 2018 13:48:35 -0700 (PDT)
Message-Id: <20181004.134835.1413543757353839906.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2018-10-04
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20181004194355.1364-1-johannes@sipsolutions.net>
References: <20181004194355.1364-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.7 on Emacs 25.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 04 Oct 2018 13:48:39 -0700 (PDT)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Thu,  4 Oct 2018 21:43:54 +0200

> I got three more fixes submitted, and am sending those to you
> now in the hope of still getting them in, although all of the
> bugs are actually older than the current cycle.
> 
> If there's a release on Sunday then I guess I won't care, but
> if not then I'd appreciate if you could pull net into net-next
> as I have at least one patch there that otherwise doesn't apply
> (at least the result wouldn't compile). Not sure if you've seen
> anything from Greg indicating either way.
> 
> Anyway, for now these fixes look good to me, so please pull or
> let me know if there's any problem.

Pulled, thanks!
