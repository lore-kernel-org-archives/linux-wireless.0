Return-Path: <SRS0=EpEU=EI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 209DDC4742C
	for <linux-wireless@archiver.kernel.org>; Mon,  2 Nov 2020 12:50:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7D7B22268
	for <linux-wireless@archiver.kernel.org>; Mon,  2 Nov 2020 12:50:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728900AbgKBMt6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 2 Nov 2020 07:49:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728599AbgKBMt6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Nov 2020 07:49:58 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A9EEC0617A6;
        Mon,  2 Nov 2020 04:49:58 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kZZHV-00HFsK-RN; Mon, 02 Nov 2020 13:49:53 +0100
Message-ID: <79a1775af358e04083c452729e74dbc8ba20fe63.camel@sipsolutions.net>
Subject: Re: pull-request: mac80211 2020-10-30
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Date:   Mon, 02 Nov 2020 13:49:37 +0100
In-Reply-To: <20201030135237.129a2cfe@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20201030094349.20847-1-johannes@sipsolutions.net>
         <20201030135237.129a2cfe@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2020-10-30 at 13:52 -0700, Jakub Kicinski wrote:
> On Fri, 30 Oct 2020 10:43:48 +0100 Johannes Berg wrote:
> > Hi Jakub,
> > 
> > Here's a first set of fixes, in particular the nl80211 eapol one
> > has people waiting for it.
> > 
> > Please pull and let me know if there's any problem.
> 
> Two patches seem to have your signature twice, do you want to respin?
> It's not a big deal.

That often happens when I pick up my own patches from the list ... let's
leave it.

johannes

