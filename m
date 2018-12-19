Return-Path: <SRS0=qpxp=O4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D0D4C43387
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 10:24:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14C7A21850
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 10:24:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727627AbeLSKYa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 19 Dec 2018 05:24:30 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:42942 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726555AbeLSKYa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Dec 2018 05:24:30 -0500
Received: from 201-0-74-183.dsl.telesp.net.br ([201.0.74.183] helo=dubbel)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gZZ1f-00057Q-CX; Wed, 19 Dec 2018 12:24:28 +0200
Message-ID: <89fb2f3d1bdd871a047a1804bd1aac9e2d376d79.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org
Date:   Wed, 19 Dec 2018 08:24:22 -0200
In-Reply-To: <87y38mx10g.fsf@kamboji.qca.qualcomm.com>
References: <20181214202945.32375-1-luca@coelho.fi>
         <20181214202945.32375-7-luca@coelho.fi>
         <87y38mx10g.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 06/18] [BUGFIXiwlwifi: make MVM and DVM depend on
 MAC80211
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2018-12-18 at 18:17 +0200, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
> 
> > From: Luca Coelho <luciano.coelho@intel.com>
> > 
> > It's not the iwlwifi module that depends on mac80211, but iwlmvm and
> > iwldvm.  To reflect this better, make MVM and DVM Kconfig options
> > depend on MAC80211 instead.
> > 
> > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> 
> The subject is broken, stray "[BUGFIX". I think you are offline already
> so I can fix it myself but I need to rebase the patches. I assume that's
> ok unless someone from Intel objects :)

Ouch, sorry.  Internal tag leaked out.  That's what happens when you try
to finish too many things in a hurry before vacations. :(

--
Luca.

