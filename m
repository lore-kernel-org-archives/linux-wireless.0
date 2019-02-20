Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08253C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 12:43:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5EB020C01
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 12:43:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727607AbfBTMnE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 07:43:04 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:34606 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726693AbfBTMnE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 07:43:04 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gwRDK-00044c-8b; Wed, 20 Feb 2019 14:43:02 +0200
Message-ID: <82c413a3c4e0f2667743b5a77573175e921870df.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org
Date:   Wed, 20 Feb 2019 14:43:01 +0200
In-Reply-To: <87a7iq1vup.fsf@codeaurora.org>
References: <20190215114924.2545-1-luca@coelho.fi>
         <87a7iq1vup.fsf@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 00/20] iwlwifi: updates intended for v5.1 2019-02-15
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2019-02-20 at 14:35 +0200, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
> 
> > Here's the nineth set of patches intended for v5.1.  It's the usual
> > development, new features, cleanups and bugfixes.
> > 
> > The changes are:
> > 
> > * Some small fixes in the new debugging infrastructure;
> > * Greg's debugfs clean-ups;
> > * Some janitorial patches from the community;
> > * Fix to one false-positive compiler warning;
> > * NSS suuport;
> 
> I was first baffled about this NSS support, but I guess you mean VHT
> extended NSS support (or something like that)?

Yes, of course.  Sorry.  I meant to write "Extended NSS support", which
would still be a bit lacking, but slightly clearer.

--
Luca.

