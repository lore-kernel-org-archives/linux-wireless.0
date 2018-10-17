Return-Path: <SRS0=hbYo=M5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F354CECDE30
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 07:25:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF21D20645
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 07:25:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF21D20645
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727366AbeJQPTf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Oct 2018 11:19:35 -0400
Received: from mga14.intel.com ([192.55.52.115]:52603 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727013AbeJQPTf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Oct 2018 11:19:35 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Oct 2018 00:25:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,391,1534834800"; 
   d="scan'208";a="79381927"
Received: from oscharmm-mobl.ger.corp.intel.com ([10.252.23.35])
  by fmsmga008.fm.intel.com with ESMTP; 17 Oct 2018 00:25:13 -0700
Message-ID: <4016573ae1c44a37bbf98c1225c02afd8b82e713.camel@intel.com>
Subject: Re: [PATCH] iwlwifi: acpi: Use kmemdup rather than duplicating its
 implementation in iwl_parse_nvm_mcc_info
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     YueHaibing <yuehaibing@huawei.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Date:   Wed, 17 Oct 2018 10:25:12 +0300
In-Reply-To: <1538730169-145458-1-git-send-email-yuehaibing@huawei.com>
References: <1538730169-145458-1-git-send-email-yuehaibing@huawei.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2018-10-05 at 09:02 +0000, YueHaibing wrote:
> Use kmemdup rather than duplicating its implementation
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---

Thanks, YueHaibing.  I have applied this in our internal tree and it
will eventually reach the mainline, following our normal upstreaming
process.

I have modified the subject and the commit message a bit.

--
Cheers,
Luca.

