Return-Path: <SRS0=xhmE=EB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E716BC4363A
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Oct 2020 10:24:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F083207E8
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Oct 2020 10:24:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1769656AbgJZKYh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 26 Oct 2020 06:24:37 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:60452 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1768771AbgJZKYh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Oct 2020 06:24:37 -0400
X-Greylist: delayed 1465 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Oct 2020 06:24:37 EDT
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kWzIR-00CsaH-B2; Mon, 26 Oct 2020 11:00:11 +0100
Message-ID: <5f31b08372573dcf97a8a2df0508151cf4402969.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211: choosing first channel from the list
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Karthikeyan Kathirvel <kathirve@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org
Date:   Mon, 26 Oct 2020 10:59:55 +0100
In-Reply-To: <1603102830-28935-1-git-send-email-kathirve@codeaurora.org> (sfid-20201019_122102_106851_B84C716C)
References: <1603102830-28935-1-git-send-email-kathirve@codeaurora.org>
         (sfid-20201019_122102_106851_B84C716C)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2020-10-19 at 15:50 +0530, Karthikeyan Kathirvel wrote:
> Though the first channel from sband channel list is invalid
> or disabled still mac80211 is choosing this disabled channel
> as a default channel for monitor interface. This will end-up
> in choosing wrong channel.
> 
> Fixed by assigning the first available valid or enabled channel
> to the respective radios.

Please fix the subject.

johannes

