Return-Path: <SRS0=9f8n=VG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 564CBC004EF
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Jul 2019 10:59:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 346E7214AF
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Jul 2019 10:59:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbfGIK7B (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Jul 2019 06:59:01 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:54462 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726411AbfGIK7B (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Jul 2019 06:59:01 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hknpk-0000pM-7d; Tue, 09 Jul 2019 13:58:53 +0300
Message-ID: <e6a6d6e6d9d94c317778e534b0fe048b7d0612ef.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Hariprasad Kelam <hariprasad.kelam@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 09 Jul 2019 13:58:50 +0300
In-Reply-To: <20190526113815.GA6328@hari-Inspiron-1545>
References: <20190526113815.GA6328@hari-Inspiron-1545>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] iwlwifi: fix warning iwl-trans.h is included more than
 once
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, 2019-05-26 at 17:08 +0530, Hariprasad Kelam wrote:
> remove duplication include of iwl-trans.h
> 
> issue identified by includecheck
> 
> Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>
> ---

Thanks! I have applied this (with small modifications to the commit
message) in our internal tree and it will reach the mainline following
our normal upstreaming process.

--
Cheers,
Luca.

