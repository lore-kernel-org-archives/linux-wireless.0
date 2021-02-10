Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D551C4332B
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Feb 2021 12:43:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2788264E63
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Feb 2021 12:43:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbhBJMm4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Feb 2021 07:42:56 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:45166 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230419AbhBJMlE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Feb 2021 07:41:04 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=[127.0.1.1])
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1l9on1-0049cJ-W6; Wed, 10 Feb 2021 14:40:16 +0200
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Luca Coelho <luca@coelho.fi>
In-Reply-To: <iwlwifi.20210210142629.a0cc944040e8.I3ae37547452b39f8040428c21ed47bdc67ae8f71@changeid>
References: <iwlwifi.20210210142629.a0cc944040e8.I3ae37547452b39f8040428c21ed47bdc67ae8f71@changeid>
To:     Luca Coelho <luca@coelho.fi>
Cc:     kvalo@codeaurora.org, linux-wireless@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.9.1+
Message-Id: <E1l9on1-0049cJ-W6@farmhouse.coelho.fi>
Date:   Wed, 10 Feb 2021 14:40:16 +0200
Subject: Re: [PATCH v2 01/12] iwlwifi: dbg: remove unsupported regions
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> wrote:

> From: Mordechay Goodstein <mordechay.goodstein@intel.com>
> 
> In case user requested to register an unsupported regions,
> remove it from active list and trigger list, this saves operational
> driver memory and run time at collecting debug data.
> 
> Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

12 patches applied to iwlwifi-next.git, thanks.

beb44c0c402a iwlwifi: dbg: remove unsupported regions
cb3abd2091af iwlwifi: api: clean up some documentation/bits
d01293154c0a iwlwifi: dbg: add op_mode callback for collecting debug data.
c52b251d1ca8 iwlwifi: declare support for triggered SU/MU beamforming feedback
1ed08f6fb5ae iwlwifi: remove flags argument for nic_access
9cd3de8106a8 iwlwifi: queue: add fake tx time point
55ae96b6acf0 iwlwifi: acpi: don't return valid pointer as an ERR_PTR
b964bfd048d3 iwlwifi: pcie: add CDB bit to the device configuration parsing
1205d7f7ffb1 iwlwifi: pcie: add AX201 and AX211 radio modules for Ma devices
781b9ae4bc0b iwlwifi: correction of group-id once sending REPLY_ERROR
abc599efa67b iwlwifi: pcie: don't crash when rx queues aren't allocated in interrupt
3ce882473ec4 iwlwifi:mvm: Add support for version 2 of the LARI_CONFIG_CHANGE command.

