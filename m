Return-Path: <SRS0=fyxI=7X=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEFCDC433DF
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Jun 2020 12:11:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D109A20734
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Jun 2020 12:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728896AbgFJMLO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Jun 2020 08:11:14 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:36602 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728558AbgFJMLN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Jun 2020 08:11:13 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=[127.0.1.1])
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1jizZE-0015Py-UK; Wed, 10 Jun 2020 15:10:53 +0300
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Luca Coelho <luca@coelho.fi>
In-Reply-To: <20200506134217.49760-1-yuehaibing@huawei.com>
References: <20200506134217.49760-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <johannes.berg@intel.com>, <emmanuel.grumbach@intel.com>,
        <luciano.coelho@intel.com>, <linuxwifi@intel.com>,
        <kvalo@codeaurora.org>, <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.8.3
Message-Id: <E1jizZE-0015Py-UK@farmhouse.coelho.fi>
Date:   Wed, 10 Jun 2020 15:10:52 +0300
Subject: Re: [PATCH] iwlwifi: mvm: Remove unused inline function
 iwl_mvm_tid_to_ac_queue
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> commit cfbc6c4c5b91 ("iwlwifi: mvm: support mac80211 TXQs model")
> left behind this, remove it.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to iwlwifi-next.git, thanks.

f12694634153 iwlwifi: mvm: Remove unused inline function iwl_mvm_tid_to_ac_queue

