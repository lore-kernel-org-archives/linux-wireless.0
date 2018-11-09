Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFFEFC43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 12:18:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9129D20825
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 12:18:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9129D20825
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbeKIV6l (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 16:58:41 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:57320 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727560AbeKIV6l (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 16:58:41 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gL5jt-0004Ug-9D; Fri, 09 Nov 2018 13:18:17 +0100
Message-ID: <d715f793b85ba2f769aabc9abd0c9a281428332f.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211:  Improve connection-loss probing.
From:   Johannes Berg <johannes@sipsolutions.net>
To:     greearb@candelatech.com, linux-wireless@vger.kernel.org
Date:   Fri, 09 Nov 2018 13:18:16 +0100
In-Reply-To: <1538071829-18527-1-git-send-email-greearb@candelatech.com> (sfid-20180927_201039_708947_1FCBD8EF)
References: <1538071829-18527-1-git-send-email-greearb@candelatech.com>
         (sfid-20180927_201039_708947_1FCBD8EF)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Ben,

Apologies for taking so long to look at this.

This looks good to me, but for some reason it doesn't apply on my
(mac80211-next) tree, and basically all of the patch fails. I'm not sure
I dare try to fix that up, could you resend?

johannes

