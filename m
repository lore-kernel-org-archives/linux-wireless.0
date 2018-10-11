Return-Path: <SRS0=d2Dv=MX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4641C32788
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 12:49:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7440320835
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 12:49:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7440320835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gondor.apana.org.au
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbeJKUQb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 16:16:31 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:52926 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726135AbeJKUQb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 16:16:31 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gAaP3-0007QC-86; Thu, 11 Oct 2018 20:49:21 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gAaOz-0003GM-AS; Thu, 11 Oct 2018 20:49:17 +0800
Date:   Thu, 11 Oct 2018 20:49:17 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Wireless <linux-wireless@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: linux-next: manual merge of the crypto tree with the
 mac80211-next tree
Message-ID: <20181011124917.iekto52aeg3ouccx@gondor.apana.org.au>
References: <20181011111329.253f0689@canb.auug.org.au>
 <1539252537.3687.209.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1539252537.3687.209.camel@sipsolutions.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Oct 11, 2018 at 12:08:57PM +0200, Johannes Berg wrote:
>
> Herbert, maybe you can drop the patch from the crypto tree since my
> change also removes the VLA usage?

Sorry but it's too late now.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
