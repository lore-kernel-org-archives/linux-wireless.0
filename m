Return-Path: <SRS0=MtVb=O3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D092DC43387
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Dec 2018 12:08:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAF9F2184C
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Dec 2018 12:08:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbeLRMIR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 18 Dec 2018 07:08:17 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:39836 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbeLRMIR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Dec 2018 07:08:17 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gZEAZ-00058e-L0; Tue, 18 Dec 2018 13:08:15 +0100
Message-ID: <08103d7adc17b89421da04bf6e299940fbf1cc07.camel@sipsolutions.net>
Subject: Re: [PATCH 00/24] cfg80211/mac80211 patches from our internal tree
 2018-12-15
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Tue, 18 Dec 2018 13:08:14 +0100
In-Reply-To: <e74b72623ab606058849339b2cabdac4bba9304d.camel@sipsolutions.net> (sfid-20181218_130703_592973_6943A5E3)
References: <20181215090325.31604-1-luca@coelho.fi>
         (sfid-20181215_100349_604857_77D32DB5) <e74b72623ab606058849339b2cabdac4bba9304d.camel@sipsolutions.net>
         (sfid-20181218_130703_592973_6943A5E3)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2018-12-18 at 13:06 +0100, Johannes Berg wrote:
> Ok...
> 
> Patch 1 is already in, from somebody else - dropped.
> Patch 12 was already in from Emmanuel - dropped.
> 
> Applied to mac80211: 9, 11, 15, 21, 24
> 
> (yes, the others are left for mac80211-next, for later)

No, also took 5 to mac80211 now.

johannes

