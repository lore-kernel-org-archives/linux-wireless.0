Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8633DC169C4
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 12:26:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EE8120870
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 12:26:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728456AbfA2M0S (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 07:26:18 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:32972 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728060AbfA2M0S (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 07:26:18 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1goST3-0007Mn-11; Tue, 29 Jan 2019 13:26:17 +0100
Message-ID: <4a698187112da01e72b833bf5b7ea74b91fc5053.camel@sipsolutions.net>
Subject: Re: [PATCH] iw: Add support for controlling tx power for per station
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Balaji Pothunoori <bpothuno@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        Ashok Raj Nagarajan <arnagara@codeaurora.org>
Date:   Tue, 29 Jan 2019 13:26:13 +0100
In-Reply-To: <6ef960abdd335dbfceeae8965c09c850@codeaurora.org>
References: <1547731764-14037-1-git-send-email-bpothuno@codeaurora.org>
         <28fbd021a9ffd4065ae76fa26872f3041aa87262.camel@sipsolutions.net>
         <6ef960abdd335dbfceeae8965c09c850@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-01-29 at 17:55 +0530, Balaji Pothunoori wrote:
> 
> Curiously asking, existing txpower set for vap/phy interface will in mBm 
> from user space.
> why would you suggesting dBm for per peer txpower set?

Yeah :-(

I basically think it's a mistake. I don't know if we can fix it now
though.

johannes

