Return-Path: <SRS0=EcM/=YO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49552CA9EAF
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Oct 2019 20:07:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25E412084C
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Oct 2019 20:07:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730238AbfJUUHt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Oct 2019 16:07:49 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:51324 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730052AbfJUUHt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Oct 2019 16:07:49 -0400
Received: from [91.156.6.193] (helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1iMdxy-0004Ny-N2; Mon, 21 Oct 2019 23:07:47 +0300
Message-ID: <0f33cba3dd5fdcc4697c26e97e8f265c1bb9958c.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Ryan Adolf <ryanadolf123@gmail.com>, linux-wireless@vger.kernel.org
Date:   Mon, 21 Oct 2019 23:07:45 +0300
In-Reply-To: <CADh-CmnrWe_hrdfs3RqL0mF4ipAxthUgE3=eBSvaiudbEtsQvw@mail.gmail.com>
References: <CADh-Cm=umBWCkz41-e0-PDnDrbpfQi_PRdT--SePmQLCqj5rwg@mail.gmail.com>
         <CADh-CmnrWe_hrdfs3RqL0mF4ipAxthUgE3=eBSvaiudbEtsQvw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1-2+b1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: Fwd: iw package typo in help command output
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2019-10-21 at 02:34 -0700, Ryan Adolf wrote:
> Hello,
> 
> First of all I'm not sure what the policy of this community is on
> typos. It's my first time contributing to iw :) If you consider this
> too minor to fix, I understand. The package has a lot of amazing stuff
> to it.

Just submit a patch! Then the maintainers will decide whether it's
worth it or not.  I, particularly, don't see why it wouldn't be taken.

--
Cheers,
Luca.

