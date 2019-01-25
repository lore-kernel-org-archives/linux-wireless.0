Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC4ECC282C2
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 19:30:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD06A217D4
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 19:30:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729134AbfAYTaN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 14:30:13 -0500
Received: from mga03.intel.com ([134.134.136.65]:47717 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726234AbfAYTaM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 14:30:12 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jan 2019 11:30:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,522,1539673200"; 
   d="scan'208";a="137834605"
Received: from mdochtor-mobl2.ger.corp.intel.com ([10.252.12.195])
  by fmsmga002.fm.intel.com with ESMTP; 25 Jan 2019 11:30:10 -0800
Message-ID: <e80a352987c756e138c20f978c9fa04e773f2211.camel@intel.com>
Subject: Re: [PATCH] iwlwifi: pcie: no need to check return value of
 debugfs_create functions
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Date:   Fri, 25 Jan 2019 21:30:09 +0200
In-Reply-To: <20190122152151.16139-21-gregkh@linuxfoundation.org>
References: <20190122152151.16139-21-gregkh@linuxfoundation.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-01-22 at 16:21 +0100, Greg Kroah-Hartman wrote:
> When calling debugfs functions, there is no need to ever check the
> return value.  The function can work or not, but the code logic
> should
> never do something different based on this.
> 
> Cc: Johannes Berg <johannes.berg@intel.com>
> Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Cc: Luca Coelho <luciano.coelho@intel.com>
> Cc: Intel Linux Wireless <linuxwifi@intel.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: linux-wireless@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---


Thanks, Greg! I applied this in our internal tree and it will reach
upstream following our normal upstreaming process.

--
Cheers,
Luca.

