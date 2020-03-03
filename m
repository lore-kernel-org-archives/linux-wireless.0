Return-Path: <SRS0=uccD=4U=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23E50C3F2D7
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Mar 2020 18:58:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07426206D7
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Mar 2020 18:58:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730576AbgCCS6p (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 3 Mar 2020 13:58:45 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:60800 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729249AbgCCS6o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Mar 2020 13:58:44 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1j9Ckc-00DUJb-FQ; Tue, 03 Mar 2020 19:58:42 +0100
Message-ID: <62f6a04e5b1231e533572bfebcae791b1ad57bb7.camel@sipsolutions.net>
Subject: Re: [PATCH wireless 0/3] nl80211: add missing attribute validation
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kvalo@codeaurora.org
Date:   Tue, 03 Mar 2020 19:58:41 +0100
In-Reply-To: <20200303095332.138ce9b7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200303051058.4089398-1-kuba@kernel.org>
         <e5d88e0dbca9cc445caa95cfe32edda52f6b193d.camel@sipsolutions.net>
         <20200303095332.138ce9b7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2020-03-03 at 09:53 -0800, Jakub Kicinski wrote:
> On Tue, 03 Mar 2020 08:29:46 +0100 Johannes Berg wrote:
> > Hi Jakub,
> > 
> > > Wireless seems to be missing a handful of netlink policy entries.  
> > 
> > Yep, these look good to me.
> > 
> > Here's a
> > 
> > Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
> > 
> > if you want to apply them directly? 
> 
> Up to Dave, I only put a maintainer hat to cover for Dave when he's
> away :)

Ah, ok; I'll just take them then, that's easier.

johannes

