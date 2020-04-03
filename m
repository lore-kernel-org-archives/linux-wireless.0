Return-Path: <SRS0=JMqe=5T=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73993C43331
	for <linux-wireless@archiver.kernel.org>; Fri,  3 Apr 2020 18:58:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B1BE206F5
	for <linux-wireless@archiver.kernel.org>; Fri,  3 Apr 2020 18:58:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbgDCS6j (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 3 Apr 2020 14:58:39 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:57442 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727167AbgDCS6j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Apr 2020 14:58:39 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jKRWS-001TBP-Ma; Fri, 03 Apr 2020 20:58:32 +0200
Message-ID: <08f1736dc95604f2a2fa47c2836251735e89ae99.camel@sipsolutions.net>
Subject: Re: [PATCH v5.7 7/8] iwlwifi: mvm: fix inactive TID removal return
 value usage
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Mark Asselstine <asselsm@gmail.com>, Luca Coelho <luca@coelho.fi>
Cc:     kvalo@codeaurora.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Date:   Fri, 03 Apr 2020 20:58:31 +0200
In-Reply-To: <CAPuovEJ7b36wEh7=8GQUx8dp_fx2AuQS4ivKb3tuHeP31HwyUQ@mail.gmail.com> (sfid-20200403_164636_006277_60796736)
References: <20200403082955.1126339-1-luca@coelho.fi>
         <iwlwifi.20200403112332.75faaf2137f4.I9e27ccc3ee3c8855fc13682592b571581925dfbd@changeid>
         <CAPuovEJ7b36wEh7=8GQUx8dp_fx2AuQS4ivKb3tuHeP31HwyUQ@mail.gmail.com>
         (sfid-20200403_164636_006277_60796736)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2020-04-03 at 10:46 -0400, Mark Asselstine wrote:
> On Fri, Apr 3, 2020 at 4:31 AM Luca Coelho <luca@coelho.fi> wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> 
> I sent Johannes part of this fix weeks ago and heard nothing back. I
> am far from a glory hound but something is wrong with this list if
> fixes are sat on for weeks and then the fix shows up with any
> acknowledgment lost. At minimum a note saying that a fix existed and
> would be merged shortly would have been nice.

Uh, sorry. I really didn't have your fix on my radar when developing
this, and cannot even remember it now.

I guess I could've saved myself some work there ...

Sorry!

johannes

