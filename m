Return-Path: <SRS0=odSX=SZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C12EC282E1
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 10:15:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E85AB21773
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 10:15:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbfDWKPa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Apr 2019 06:15:30 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:59130 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbfDWKPa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Apr 2019 06:15:30 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hIsSL-0004tc-RB; Tue, 23 Apr 2019 12:15:17 +0200
Message-ID: <9ebd031d208aae52b787905eb4fb5e04a1d52969.camel@sipsolutions.net>
Subject: Re: [linux-next] rtlwifi commit contains a patch reject file
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Cc:     Larry Finger <Larry.Finger@lwfinger.net>,
        linux-next@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>
Date:   Tue, 23 Apr 2019 12:15:16 +0200
In-Reply-To: <20190422125926.15862fdd@canb.auug.org.au> (sfid-20190422_045942_518263_99E79F6A)
References: <20190420155008.GM23044@windriver.com>
         <20190422125926.15862fdd@canb.auug.org.au>
         (sfid-20190422_045942_518263_99E79F6A)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2019-04-22 at 12:59 +1000, Stephen Rothwell wrote:

> I have added that test to my commit checks now.  Thanks for the
> suggestion.  So far it only checks for .rej and .orig files - any
> others?

Maybe consider the things listed in the .gitignore file? Those are quite
difficult to add (git add -f) but I think I've seen it happen before,
perhaps through different trees etc.

In fact, *.orig is listed in .gitignore, I wonder why *.rej isn't? Maybe
so it stands out more in "git status"?

johannes

