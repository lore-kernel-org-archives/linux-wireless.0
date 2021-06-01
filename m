Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 535E4C47080
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Jun 2021 08:36:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33CED6128A
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Jun 2021 08:36:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233098AbhFAIh7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 1 Jun 2021 04:37:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:38610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231139AbhFAIh6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Jun 2021 04:37:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B6D36128A;
        Tue,  1 Jun 2021 08:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622536576;
        bh=1wM7BhavxCHJ42w0fAh62uzg9mdYB49RA48MG1C/oFw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CC9FlgvQ1X5ZIOBOlE+mHSIM/hkurxqlaFoe7dk0hTYJafgOytcdq6JaSZjNKrMCn
         U6zQDMSJNmlEpI6Zp+MPOcpOOEagHYPZamn3CK3TEYINLP1eBb0+bnNiAJM//v/PLS
         O+eqyVsmQlY/n3S2ynCm3BfVJhd7hIFvBMiXcSnk=
Date:   Tue, 1 Jun 2021 10:36:13 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v4.4 00/10] security fixes backports
Message-ID: <YLXxfbpaPRz9yd2W@kroah.com>
References: <20210531202834.179810-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210531202834.179810-1-johannes@sipsolutions.net>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, May 31, 2021 at 10:28:24PM +0200, Johannes Berg wrote:
> One or two of the patches here were already applied since they
> applied cleanly, but I'm resending the whole set for review now
> anyway.

All now queued up, thanks!

greg k-h
