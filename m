Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03D57C6787C
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 17:57:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3F1C21477
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 17:57:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C3F1C21477
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=davemloft.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbeJMBbd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 21:31:33 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48084 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbeJMBbd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 21:31:33 -0400
Received: from localhost (c-67-183-145-105.hsd1.wa.comcast.net [67.183.145.105])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3AD0B133FACA8;
        Fri, 12 Oct 2018 10:57:53 -0700 (PDT)
Date:   Fri, 12 Oct 2018 10:57:50 -0700 (PDT)
Message-Id: <20181012.105750.1056107782666887474.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2018-10-12
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20181012111354.30062-1-johannes@sipsolutions.net>
References: <20181012111354.30062-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.7 on Emacs 26 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 12 Oct 2018 10:57:53 -0700 (PDT)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 12 Oct 2018 13:13:53 +0200

> Here's another set of updates. Note that there's a patch here
> (lib80211 skcipher removal to simplify the code) that will
> cause conflicts when merging with the crypto tree, the new
> code from this should be used. Please advise Greg/Linus unless
> the crypto tree will somehow end up in your tree first?
> 
> Please pull and let me know if there's any problem.

Thanks I will keep that merge issue in mind.

Even if I forget, Linus and Greg are adults and usually can sort
things like that out. :-)

Really nice to see the new netlink validation code put to use.
