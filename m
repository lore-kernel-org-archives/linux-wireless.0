Return-Path: <SRS0=cSSL=QN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 620E4C169C4
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 05:47:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 385E62080A
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 05:47:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727581AbfBFFrN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Feb 2019 00:47:13 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:55502 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725897AbfBFFrN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Feb 2019 00:47:13 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1grG3C-000140-KF; Wed, 06 Feb 2019 07:47:11 +0200
Message-ID: <4ee2f6705073253c8925241f9d72481b79934e43.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
Date:   Wed, 06 Feb 2019 07:47:09 +0200
In-Reply-To: <9a07e9fc236ce6d526dfd67ee9b322953525c426.camel@sipsolutions.net>
References: <20181215090325.31604-1-luca@coelho.fi>
         <20181215090325.31604-14-luca@coelho.fi>
         <9a07e9fc236ce6d526dfd67ee9b322953525c426.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 13/24] cfg80211: pmsr: fix MAC address setting
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2018-12-18 at 13:17 +0100, Johannes Berg wrote:
> On Sat, 2018-12-15 at 11:03 +0200, Luca Coelho wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > When we *don't* have a MAC address attribute, we shouldn't
> > try to use this - this was intended to copy the local MAC
> > address instead, so fix it.
> 
> This patch
> 
> >  
> > +	flush_work(&wdev->pmsr_free_wk);
> 
> Erroneously got some other stuff merged into it - dropped.

That's because I squashed some other patches that said to fix this one
into it.  I'll update the commit message so it makes more sense and
resend.

--
Cheers,
Luca.

