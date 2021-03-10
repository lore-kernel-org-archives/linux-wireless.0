Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9072C433DB
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Mar 2021 09:51:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7053664F8A
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Mar 2021 09:51:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbhCJJum (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Mar 2021 04:50:42 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:48394 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230525AbhCJJuM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Mar 2021 04:50:12 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=[192.168.100.150])
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1lJvTk-004SJd-4Y; Wed, 10 Mar 2021 11:50:08 +0200
Message-ID: <ef3f23b48013acf22b07e2b13be10a5cbce5fdd7.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
List-Id: <linux-firmware.lore.kernel.org>
To:     Thomas Backlund <tmb@tmb.nu>,
        "linux-firmware@kernel.org" <linux-firmware@kernel.org>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kyle@infradead.org" <kyle@infradead.org>,
        "jwboyer@kernel.org" <jwboyer@kernel.org>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>,
        golan.ben.ami@intel.com
Date:   Wed, 10 Mar 2021 11:50:06 +0200
In-Reply-To: <dc668115-049c-0bbc-b25e-917ccf1bbdee@tmb.nu>
References: <8e3877efc92f413d47ee1d71a119885c765d7312.camel@coelho.fi>
         <69d01bfd-a15f-2ebb-b55a-c6864a065e1f@tmb.nu>
         <42eb781e8f89b92ff54a4d65b0916d420eb2a381.camel@coelho.fi>
         <dc668115-049c-0bbc-b25e-917ccf1bbdee@tmb.nu>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull request: iwlwifi firmware updates 2021-03-05-v2
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2021-03-10 at 09:46 +0000, Thomas Backlund wrote:
> Den 10.3.2021 kl. 11:26, skrev Luca Coelho:
> 
> > > Luca Coelho (3):
> > >        iwlwifi: update 7265D firmware
> > > 
> > > This one looks old... stuck in limbo for over 1.5 years... is that
> > > correct ?
> > > author    Luca Coelho <luciano.coelho@intel.com>    2019-08-23
> > > 07:35:14 +0300
> > >   committer    Luca Coelho <luciano.coelho@intel.com>    2021-03-05
> > > 11:37:56 +0200
> > Oh, I just reused the commit message from before and edited it as
> > needed.  Does it really matter?
> 
> 
> I guess not..
> 
> it was more a "is it acctually a correct commit " as it looked weird
> when being so old...
> 
> considering the last update to the same firmware happend on 2020-10-14

I guess I've been reusing them for quite a while. ;)

--
Luca.

