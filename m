Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5211C64E8A
	for <linux-wireless@archiver.kernel.org>; Thu,  3 Dec 2020 11:09:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D513208FE
	for <linux-wireless@archiver.kernel.org>; Thu,  3 Dec 2020 11:09:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388931AbgLCLJm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 3 Dec 2020 06:09:42 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:34162 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388874AbgLCLJl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Dec 2020 06:09:41 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=[192.168.100.69])
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1kkmTm-0038JE-5u; Thu, 03 Dec 2020 13:08:54 +0200
Message-ID: <03c36d6a1fe97356239626e66e69255ad0fd88fc.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Thu, 03 Dec 2020 13:08:52 +0200
In-Reply-To: <iwlwifi.20201129151117.70e3f540af9a.Idb157cfb560397421c184cbf54450d90f03bf7ec@changeid>
References: <20201129131442.1857561-1-luca@coelho.fi>
         <iwlwifi.20201129151117.70e3f540af9a.Idb157cfb560397421c184cbf54450d90f03bf7ec@changeid>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 05/12] cfg80211: flush scan entries upon suspend
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, 2020-11-29 at 15:14 +0200, Luca Coelho wrote:
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> 
> When we suspend, we can't really remember our BSS table.
> Purge all the data.
> Export this function to allow driver to purge the BSS table
> in case they feel the need to.
> iwlwifi will need to do that.
> 
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> ---

This is obviously out of place and we already have an implementation
for this upstream.  Johannes dropped it.  Sorry for the trouble. :(

--
Luca.

