Return-Path: <SRS0=H9Fc=TO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18F54C04AB4
	for <linux-wireless@archiver.kernel.org>; Tue, 14 May 2019 18:40:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBD7120879
	for <linux-wireless@archiver.kernel.org>; Tue, 14 May 2019 18:40:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727659AbfENSkO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 14 May 2019 14:40:14 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:50848 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbfENSkK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 May 2019 14:40:10 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hQcLN-0005ZC-CY; Tue, 14 May 2019 20:40:05 +0200
Message-ID: <8eacb8e107c854b64a0c6116fca9731ddd99dcac.camel@sipsolutions.net>
Subject: Re: [PATCH v2] mac80211: remove warning message
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ben Greear <greearb@candelatech.com>,
        Joe Perches <joe@perches.com>, Yibo Zhao <yiboz@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Zhi Chen <zhichen@codeaurora.org>
Date:   Tue, 14 May 2019 20:40:03 +0200
In-Reply-To: <4d013893-3302-14f0-c957-b3771f4b6b82@candelatech.com>
References: <1557824507-17668-1-git-send-email-yiboz@codeaurora.org>
         <7c92f5cf51eaec1d5449698d90f5b6c5ca6c2bea.camel@sipsolutions.net>
         <ccb48284f0d96e72f4c041e12c943f0a@codeaurora.org>
         <e2a6596b99085541a5886c0d0d6393c849ac2d57.camel@sipsolutions.net>
         <34f72d5db336b9898618bf1c5c15ec41094d7d06.camel@perches.com>
         <4d013893-3302-14f0-c957-b3771f4b6b82@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


> We know the WARN hits, we have the backtrace, and it is easy enough (in my setup
> at least) to reproduce this.  So, the WARN logic has done its job.
> 
> Having more of these spam the kernel doesn't add much benefit I think.

Well, this doesn't necessarily just catch a *single* issue, so it should
remain for the future, I'd think.

> Anyone have any suggestions on how to fix the underlying issue?

I don't even have the backtrace and scenario that causes it.

johannes

