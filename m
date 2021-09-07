Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D2B8C433F5
	for <linux-wireless@archiver.kernel.org>; Tue,  7 Sep 2021 12:12:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0905B606A5
	for <linux-wireless@archiver.kernel.org>; Tue,  7 Sep 2021 12:12:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343607AbhIGMNs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 7 Sep 2021 08:13:48 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:56108 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229604AbhIGMNr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Sep 2021 08:13:47 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=[192.168.100.150])
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <luca@coelho.fi>)
        id 1mNZxu-0007a1-Oq; Tue, 07 Sep 2021 15:12:39 +0300
Message-ID: <b644e58618825e69788117e53fcf17dc4a81bda5.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, dan.carpenter@oracle.com
Date:   Tue, 07 Sep 2021 15:12:37 +0300
In-Reply-To: <iwlwifi.20210907143156.e80e52167d93.Ie2247f43f8acb2cee6dff5b07a3947c79a772835@changeid>
References: <iwlwifi.20210907143156.e80e52167d93.Ie2247f43f8acb2cee6dff5b07a3947c79a772835@changeid>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] iwlwifi: mvm: Fix possible NULL dereference
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2021-09-07 at 14:32 +0300, Luca Coelho wrote:
> From: Ilan Peer <ilan.peer@intel.com>
> 
> In __iwl_mvm_remove_time_event() check that 'te_data->vif' is NULL
> before dereferencing it.
> 
> Fixes: 7b3954a1d69a ("iwlwifi: mvm: Explicitly stop session protection before unbinding")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Ilan Peer <ilan.peer@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> ---

Kalle, I assigned this to you.  Can you please take it directly to
wireless-drivers for v5.15?

Thanks!

--
Cheers,
Luca.

