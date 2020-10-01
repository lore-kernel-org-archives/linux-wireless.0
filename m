Return-Path: <SRS0=X78v=DI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C8EEC4727E
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Oct 2020 18:57:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1713C20872
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Oct 2020 18:57:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730045AbgJAS5G (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 1 Oct 2020 14:57:06 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:53638 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729047AbgJAS5F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Oct 2020 14:57:05 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=[127.0.1.1])
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1kO3lH-002NBy-CP; Thu, 01 Oct 2020 21:57:03 +0300
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Luca Coelho <luca@coelho.fi>
In-Reply-To: <iwlwifi.20200924162105.862ef88d1ab2.Iba220a962b5d6d05c030b9275d97a89202d055dc@changeid>
References: <iwlwifi.20200924162105.862ef88d1ab2.Iba220a962b5d6d05c030b9275d97a89202d055dc@changeid>
To:     Luca Coelho <luca@coelho.fi>
Cc:     kvalo@codeaurora.org, linux-wireless@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.8.6
Message-Id: <E1kO3lH-002NBy-CP@farmhouse.coelho.fi>
Date:   Thu, 01 Oct 2020 21:57:03 +0300
Subject: Re: [PATCH 2/7] iwlwifi: iwl-trans: move all txcmd init to trans
 alloc
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> wrote:

> From: Mordechay Goodstein <mordechay.goodstein@intel.com>
> 
> txcmd fields is not directly related to the PCIe transport,
> so move to the common iwl_trans_alloc function.
> 
> Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

6 patches applied to iwlwifi-next.git, thanks.

fda1bd0d4a6b iwlwifi: iwl-trans: move all txcmd init to trans alloc
a26014e2de3f iwlwifi: move bc_pool to a common trans header
885375d0bb9f iwlwifi: iwl-trans: move tfd to trans layer
8e3b79f887b9 iwlwifi: move bc_table_dword to a common trans header
bc9296f4a828 iwlwifi: add new cards for MA family
f2134f66f40e iwlwifi: acpi: support ppag table command v2

