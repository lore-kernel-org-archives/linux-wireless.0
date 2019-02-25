Return-Path: <SRS0=l+aR=RA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4453DC10F00
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Feb 2019 05:55:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B6B42087C
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Feb 2019 05:55:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbfBYFzM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Feb 2019 00:55:12 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:35526 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbfBYFzM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Feb 2019 00:55:12 -0500
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::bf5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 89A4814DF1AA4;
        Sun, 24 Feb 2019 21:55:11 -0800 (PST)
Date:   Sun, 24 Feb 2019 21:55:10 -0800 (PST)
Message-Id: <20190224.215510.1302203137259056114.davem@davemloft.net>
To:     herbert@gondor.apana.org.au
Cc:     dan.carpenter@oracle.com, kbuild@01.org, kbuild-all@01.org,
        linux-wireless@vger.kernel.org, johannes.berg@intel.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] ila: Fix uninitialised return value in
 ila_xlat_nl_cmd_flush
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190223053047.tiwcuvs6tcg2htie@gondor.apana.org.au>
References: <20190223042747.GK1711@kadam>
        <20190223053047.tiwcuvs6tcg2htie@gondor.apana.org.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 24 Feb 2019 21:55:11 -0800 (PST)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Sat, 23 Feb 2019 13:30:47 +0800

> This patch fixes an uninitialised return value error in
> ila_xlat_nl_cmd_flush.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Fixes: 6c4128f65857 ("rhashtable: Remove obsolete...")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Applied, thanks Herbert.
