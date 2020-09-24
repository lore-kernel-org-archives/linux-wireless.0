Return-Path: <SRS0=SYB6=DB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92BD4C4363D
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Sep 2020 21:32:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C0F82399A
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Sep 2020 21:32:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgIXVcw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 24 Sep 2020 17:32:52 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:52182 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725208AbgIXVcw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Sep 2020 17:32:52 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=[192.168.100.69])
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1kLYrA-002IWG-Sf; Fri, 25 Sep 2020 00:32:50 +0300
Message-ID: <69bffaa2a39667b6b042e7fa11e509882aad60c2.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 25 Sep 2020 00:32:46 +0300
In-Reply-To: <87mu1fkrl2.fsf@codeaurora.org>
References: <20200924132339.337310-1-luca@coelho.fi>
         <iwlwifi.20200924162105.c12a9b75da6b.I181fc5c80988e7ecea281c60e57a22ae7ec86716@changeid>
         <87mu1fkrl2.fsf@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/7] iwlwifi: enable twt by default
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2020-09-24 at 20:33 +0300, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
> 
> > From: Golan Ben Ami <golan.ben.ami@intel.com>
> > 
> > In a previous patch, a flag for disabling twt by a dbg-cfg
> > was added. This will be useful for disabling twt on specific
> > cores, after branch-out.
> > However, we'd like twt to be enabled on master.
> > 
> > So, enable twt on master.
> 
> What's master in this context? AP mode?

Doh, sorry! This is a totally internal-based commit message language.
 I'll fix it.

"master" is the master branch, as opposed to "cores" which are stable
branches.

--
Cheers,
Luca.

