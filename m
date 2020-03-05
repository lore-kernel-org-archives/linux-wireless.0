Return-Path: <SRS0=q56x=4W=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3FBEC3F2D1
	for <linux-wireless@archiver.kernel.org>; Thu,  5 Mar 2020 16:44:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0C8520637
	for <linux-wireless@archiver.kernel.org>; Thu,  5 Mar 2020 16:44:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbgCEQoi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 5 Mar 2020 11:44:38 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:60768 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725944AbgCEQoh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Mar 2020 11:44:37 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <luca@coelho.fi>)
        id 1j9tbv-0005UW-Af; Thu, 05 Mar 2020 18:44:35 +0200
Message-ID: <39c51b932b8a5588ea6ec8a040255fb56b498214.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org
Date:   Thu, 05 Mar 2020 18:44:33 +0200
In-Reply-To: <87ftemq2ik.fsf@kamboji.qca.qualcomm.com>
References: <iwlwifi.20200305142622.3b1f9018cd2e.Iccbce3e78befd4ac39735b26617cfb6a12a2ae5a@changeid>
         <87ftemq2ik.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1-4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] MAINTAINERS: update web URL for iwlwifi
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2020-03-05 at 16:50 +0200, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
> 
> > From: Luca Coelho <luciano.coelho@intel.com>
> > 
> > The current URL mentioned in iwlwifi's W entry is outdated and
> > currently pointing to a dead link.  Change it so that it points to the
> > correct Wiki page directly.
> > 
> > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> 
> I'll queue this for v5.6, ok?

Sure, if you think it's worth it.  TBH my main goal to send this one by
itself was to test my "Link:"-adding setup (with Johannes' scripts). ;)

--
Cheers,
Luca.

