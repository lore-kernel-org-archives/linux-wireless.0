Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF7FCC4360F
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 06:58:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A883A222A4
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 06:58:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405968AbfBNG6E (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 01:58:04 -0500
Received: from mga01.intel.com ([192.55.52.88]:54744 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405705AbfBNG6E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 01:58:04 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Feb 2019 22:58:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,367,1544515200"; 
   d="scan'208";a="143346593"
Received: from hnswanep-mobl.amr.corp.intel.com ([10.252.8.171])
  by fmsmga002.fm.intel.com with ESMTP; 13 Feb 2019 22:58:01 -0800
Message-ID: <bb3c1e934da9fa306b1e3f4660fd400c33dc67a8.camel@intel.com>
Subject: Re: [PATCH v2 2/2] iwlwifi: Use struct_size() in kzalloc
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     YueHaibing <yuehaibing@huawei.com>, johannes.berg@intel.com,
        emmanuel.grumbach@intel.com, linuxwifi@intel.com,
        kvalo@codeaurora.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Date:   Thu, 14 Feb 2019 08:58:00 +0200
In-Reply-To: <20190129032144.18120-3-yuehaibing@huawei.com>
References: <20190129032144.18120-1-yuehaibing@huawei.com>
         <20190129032144.18120-3-yuehaibing@huawei.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-01-29 at 11:21 +0800, YueHaibing wrote:
> Use struct_size() in kzalloc instead of the 'regd_to_copy'
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---

Applied to our internal tree and it will reach the mainline following
our normal upstreaming process.

Thanks!

--
Luca.

