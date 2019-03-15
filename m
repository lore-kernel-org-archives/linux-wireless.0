Return-Path: <SRS0=bI0Y=RS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A9CCC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 16:40:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59F6E20854
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 16:40:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729590AbfCOQku (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Mar 2019 12:40:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:9773 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729428AbfCOQku (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Mar 2019 12:40:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Mar 2019 09:40:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,482,1544515200"; 
   d="scan'208";a="283012012"
Received: from avarleyx-mobl.ger.corp.intel.com ([10.252.13.147])
  by orsmga004.jf.intel.com with ESMTP; 15 Mar 2019 09:40:48 -0700
Message-ID: <0cf2145dcbdae5c94beefea7f6681be325e0bbd1.camel@intel.com>
Subject: Re: [PATCH 06/16] mac80211_hwsim: make copying of ciphers safer by
 checking the length
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     kvalo@codeaurora.org, johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 15 Mar 2019 18:40:47 +0200
In-Reply-To: <20190315163634.17315-7-luca@coelho.fi>
References: <20190315163634.17315-1-luca@coelho.fi>
         <20190315163634.17315-7-luca@coelho.fi>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2019-03-15 at 18:36 +0200, Luca Coelho wrote:
> From: Luca Coelho <luciano.coelho@intel.com>
> 
> Make sure the length of the ciphers we are copying never exceeds the
> space we have for storing them.  There is no risk of overcopying at
> the moment, because we check n_params before, but this makes this
> function safer in case someone changes something in the future.
> 
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> ---

Ooops, this one should obviously not go through my tree.  Johannes, can
you please take it? I've removed from my tree and won't include it as
part of my pull-request.

I'll also check patchwork and make sure it's under Johannes' name.

--
Cheers,
Luca.

