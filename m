Return-Path: <SRS0=6FTc=OM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0ECDC04EB9
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 12:38:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72E1320850
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 12:38:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 72E1320850
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbeLCMjX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 3 Dec 2018 07:39:23 -0500
Received: from mga11.intel.com ([192.55.52.93]:48552 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726478AbeLCMjW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Dec 2018 07:39:22 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Dec 2018 04:38:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,310,1539673200"; 
   d="scan'208";a="104412723"
Received: from ggrimlan-mobl1.ger.corp.intel.com ([10.252.29.76])
  by fmsmga007.fm.intel.com with ESMTP; 03 Dec 2018 04:38:27 -0800
Message-ID: <1773a3329bcd1bde2a22c267e4c582b0149a307e.camel@intel.com>
Subject: Re: linux-next: build warnings after merge of the
 wireless-drivers-next tree
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Wireless <linux-wireless@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sara Sharon <sara.sharon@intel.com>,
        Kees Cook <keescook@google.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Date:   Mon, 03 Dec 2018 14:38:26 +0200
In-Reply-To: <87h8fz57ty.fsf@kamboji.qca.qualcomm.com>
References: <20181130120555.1d35eb6b@canb.auug.org.au>
         <87lg5b5glw.fsf@kamboji.qca.qualcomm.com>
         <20181130165006.60b2545f@canb.auug.org.au>
         <87h8fz57ty.fsf@kamboji.qca.qualcomm.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2018-11-30 at 09:43 +0200, Kalle Valo wrote:
> Stephen Rothwell <sfr@canb.auug.org.au> writes:
> 
> > Hi Kalle,
> > 
> > On Fri, 30 Nov 2018 06:33:47 +0200 Kalle Valo <kvalo@codeaurora.org
> > > wrote:
> > > I take it that -Wimplict-fallthrough is not enabled by default
> > > yet? So
> > > Dave and Linus won't see these warnings?
> > 
> > Correct.
> > 
> > > What I'm planning is to send a pull request to Dave today and fix
> > > these
> > > warnings in the next pull request. Does that sound good?
> > 
> > That sounds fine.
> 
> Great, thanks for the confirmation. I'll then send the pull request
> today.

Just FYI, I enabled this by default in our internal tree so we will
notice when it happens before sending the patch upstream.

--
Cheers,
Luca.

