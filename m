Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 839FCC282C3
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 11:02:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D10420879
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 11:02:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727985AbfAVLCg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 06:02:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:19761 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727048AbfAVLCf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 06:02:35 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Jan 2019 03:02:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,506,1539673200"; 
   d="scan'208";a="268937555"
Received: from cmicsa-mobl1.ti.intel.com ([10.252.18.12])
  by orsmga004.jf.intel.com with ESMTP; 22 Jan 2019 03:02:32 -0800
Message-ID: <c1ef87b6a64dac81398278744f0d7678df9e107f.camel@intel.com>
Subject: Re: [PATCH] iwlwifi: mvm: remove duplicated include from ops.c
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     YueHaibing <yuehaibing@huawei.com>, johannes.berg@intel.com,
        emmanuel.grumbach@intel.com, linuxwifi@intel.com,
        kvalo@codeaurora.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Date:   Tue, 22 Jan 2019 13:02:32 +0200
In-Reply-To: <20190117070002.15352-1-yuehaibing@huawei.com>
References: <20190117070002.15352-1-yuehaibing@huawei.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2019-01-17 at 15:00 +0800, YueHaibing wrote:
> Remove duplicated include.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---

Dropped, this is a duplicate.

--
Cheers,
Luca.

