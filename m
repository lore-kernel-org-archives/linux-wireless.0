Return-Path: <SRS0=odSX=SZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 045FEC10F14
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 08:58:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAAC420674
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 08:58:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbfDWI6h (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Apr 2019 04:58:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:35672 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbfDWI6h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Apr 2019 04:58:37 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Apr 2019 01:58:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,385,1549958400"; 
   d="scan'208";a="144913121"
Received: from ipoitasu-mobl.ger.corp.intel.com ([10.252.17.11])
  by orsmga003.jf.intel.com with ESMTP; 23 Apr 2019 01:53:54 -0700
Message-ID: <34edd015c5c44054a4d85fc0fd30ff6cfaa1f3fb.camel@intel.com>
Subject: Re: [PATCH 0/8] iwlwifi: updates intended for v5.2 2019-04-23
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Tue, 23 Apr 2019 11:53:53 +0300
In-Reply-To: <20190423085014.15390-1-luca@coelho.fi>
References: <20190423085014.15390-1-luca@coelho.fi>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-04-23 at 11:50 +0300, Luca Coelho wrote:
> From: Luca Coelho <luciano.coelho@intel.com>
> 
> Hi,
> 
> Here's the fifth set of patches intended for v5.2.  It's the usual
> development, new features, cleanups and bugfixes.
> 
> The changes are:
> 
> * Fix a bug we introduced in the RX path in a previous patch;
> * Add command version parsing from the FW TLVs;
> * Some fixes and improvements in the new debugging framework;
> * One tiny janitorial fix to remove a stray character;
> 
> As usual, I'm pushing this to a pending branch, for kbuild bot, and
> will send a pull-request later.
> 
> Please review.
> 
> Cheers,
> Luca.

Sorry, ignore this, I missed a bunch of patches before this series.

--
Luca.

