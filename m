Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3370C169C4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 10:03:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C11F7218D3
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 10:03:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731901AbfAaKDS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 05:03:18 -0500
Received: from mga18.intel.com ([134.134.136.126]:13836 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726316AbfAaKDP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 05:03:15 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jan 2019 02:03:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,543,1539673200"; 
   d="scan'208";a="122828573"
Received: from mgrymel-mobl1.ger.corp.intel.com ([10.252.19.184])
  by orsmga003.jf.intel.com with ESMTP; 31 Jan 2019 02:03:13 -0800
Message-ID: <1aa24e0ef6d80535e947f74e6aa21759122df517.camel@intel.com>
Subject: Re: [PATCH 14/17] iwlwifi: fix fallthrough comment in iwl-dnt-cfg.c
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>
Date:   Thu, 31 Jan 2019 12:03:12 +0200
In-Reply-To: <20190130115528.19922-15-luca@coelho.fi>
References: <20190130115528.19922-1-luca@coelho.fi>
         <20190130115528.19922-15-luca@coelho.fi>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2019-01-30 at 13:55 +0200, Luca Coelho wrote:
> From: Shahar S Matityahu <shahar.s.matityahu@intel.com>
> 
> I placed the fall through comment in the wrong case.  Move it to the
> right place.
> 
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> ---

Oops, this came out with the wrong commit message, I'll replace it with
the proper one.

--
Luca.

