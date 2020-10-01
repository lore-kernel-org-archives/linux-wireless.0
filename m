Return-Path: <SRS0=X78v=DI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45B62C4727E
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Oct 2020 18:56:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A8F620882
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Oct 2020 18:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729927AbgJAS4T (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 1 Oct 2020 14:56:19 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:53630 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729047AbgJAS4T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Oct 2020 14:56:19 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=[127.0.1.1])
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1kO3kX-002NBi-39; Thu, 01 Oct 2020 21:56:17 +0300
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Luca Coelho <luca@coelho.fi>
In-Reply-To: <iwlwifi.20200928093526.44c9093fc632.I181fc5c80988e7ecea281c60e57a22ae7ec86716@changeid>
References: <iwlwifi.20200928093526.44c9093fc632.I181fc5c80988e7ecea281c60e57a22ae7ec86716@changeid>
To:     Luca Coelho <luca@coelho.fi>
Cc:     kvalo@codeaurora.org, linux-wireless@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.8.6
Message-Id: <E1kO3kX-002NBi-39@farmhouse.coelho.fi>
Date:   Thu, 01 Oct 2020 21:56:17 +0300
Subject: Re: [PATCH v2 1/7] iwlwifi: enable twt by default
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> wrote:

> From: Golan Ben Ami <golan.ben.ami@intel.com>
> 
> TWT has been disabled during stabilization and further testing of the
> FW code.  It is now considered stable, so TWT can be enabled in the
> driver.
> 
> Signed-off-by: Golan Ben Ami <golan.ben.ami@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

Patch applied to iwlwifi-next.git, thanks.

ccca2cb4c118 iwlwifi: enable twt by default

