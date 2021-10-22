Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD12AC433F5
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Oct 2021 07:48:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A45AF60231
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Oct 2021 07:48:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbhJVHuw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Oct 2021 03:50:52 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:57020 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S232021AbhJVHuw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Oct 2021 03:50:52 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=[192.168.100.150])
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <luca@coelho.fi>)
        id 1mdpI0-000bhC-PB; Fri, 22 Oct 2021 10:48:33 +0300
Message-ID: <cbffcc3e4e7e00e007df01201e8de375ffc70128.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 22 Oct 2021 10:48:31 +0300
In-Reply-To: <iwlwifi.20211017165728.d931a48ad8bd.I9b027837cba3478c9bb74c3f07df48eaef70a197@changeid>
References: <20211017135954.504836-1-luca@coelho.fi>
         <iwlwifi.20211017165728.d931a48ad8bd.I9b027837cba3478c9bb74c3f07df48eaef70a197@changeid>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.0-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 07/10] wlwifi: add new device id 7F70
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, 2021-10-17 at 16:59 +0300, Luca Coelho wrote:
> From: Yaara Baruch <yaara.baruch@intel.com>
> 
> Add new 7F70 device to cards id struct.
> Add new 7F70 DID killers devices.
> 
> Signed-off-by: Yaara Baruch <yaara.baruch@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> ---

There's a typo in the commit message in this patch ("wlwifi" instead of
"iwlwifi").  I'll fix it when I apply it.

--
Cheers,
Luca.

