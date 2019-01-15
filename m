Return-Path: <SRS0=v11p=PX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2C78C43387
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 13:13:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9D1A20657
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 13:13:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729319AbfAONNM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Jan 2019 08:13:12 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:56180 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728066AbfAONNM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Jan 2019 08:13:12 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gjOWj-0007RL-B9; Tue, 15 Jan 2019 14:13:09 +0100
Message-ID: <efe6a7978b1cc6287f122d8e829d8bd318466849.camel@sipsolutions.net>
Subject: Re: [PATCH] nl80211/cfg80211: Add support to send tx frames at
 specified rate
From:   Johannes Berg <johannes@sipsolutions.net>
To:     vamsin@codeaurora.org, Ben Greear <greearb@candelatech.com>
Cc:     linux-wireless@vger.kernel.org, jouni@codeaurora.org
Date:   Tue, 15 Jan 2019 14:13:07 +0100
In-Reply-To: <63224d0fc1e978624de9887cb7349c02@codeaurora.org>
References: <1543838646-3574-1-git-send-email-vamsin@codeaurora.org>
         <89e6532daf4011de2ad0df3dcb8accc42334f31e.camel@sipsolutions.net>
         <899698ca-d8b5-45b1-5689-58096e2f0291@candelatech.com>
         <63224d0fc1e978624de9887cb7349c02@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-01-08 at 23:19 +0530, vamsin@codeaurora.org wrote:

> Unfortunately, the driver that I am working now is not upstreamed. I 
> would like to check with Ben if he likes to propose a patch ath10k 
> driver that he is working on as I see he is also interested in this 
> feature. Please let me know if it is mandatory or good to have driver 
> implementation.

I'm not sure it really has to be *mandatory*, but if nobody else even
wants to have support for this (and e.g. iwlwifi cannot even easily do
this I believe) then what value does something have upstream?

johannes

