Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3160CC43441
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 19:02:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC98622419
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 19:02:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC98622419
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729164AbeKME5L (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 23:57:11 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:35504 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727530AbeKME5K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 23:57:10 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gMHTp-0007LG-Ja; Mon, 12 Nov 2018 20:02:37 +0100
Message-ID: <077070b29fd720cad4b43f33babf7335c5a66818.camel@sipsolutions.net>
Subject: Re: [PATCH v5] iw: ack signal support for tx ack packets
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Balaji Pothunoori <bpothuno@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org
Date:   Mon, 12 Nov 2018 20:02:36 +0100
In-Reply-To: <092e18e05296d9e2e7e8580603ac8b1d@codeaurora.org>
References: <1532010590-475-1-git-send-email-bpothuno@codeaurora.org>
         <092e18e05296d9e2e7e8580603ac8b1d@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2018-11-12 at 21:56 +0530, Balaji Pothunoori wrote:
> Hi Johannes,
> 
> Now that corresponding driver patches are merged, could you please let 
> me know if anything is left from our end for merging this patch?

Oh, I marked this as "changes requested" since I thought the updates we
discussed on the kernel side would require changes here (IIRC we talked
about changing some names?)

If it applies and compiles as is, I guess best if you just resend, since
I no longer have it in patchwork and am on vacation this week.

johannes

