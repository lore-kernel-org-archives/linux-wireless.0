Return-Path: <SRS0=YfBD=WY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EAE9C3A5A1
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Aug 2019 20:37:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC5C920828
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Aug 2019 20:37:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbfH1Uhx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 28 Aug 2019 16:37:53 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:42448 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbfH1Uhw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Aug 2019 16:37:52 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.1)
        (envelope-from <johannes@sipsolutions.net>)
        id 1i34hS-0000bq-Na; Wed, 28 Aug 2019 22:37:50 +0200
Message-ID: <1d14994df1c4e9dd83fcd76a1d99ce7b23067bd5.camel@sipsolutions.net>
Subject: Re: [PATCH] mwifiex: Fix three heap overflow at parsing element in
 cfg80211_ap_settings
From:   Johannes Berg <johannes@sipsolutions.net>
To:     huangwenabc@gmail.com, linux-wireless@vger.kernel.org
Cc:     amitkarwar@gmail.com, nishants@marvell.com, gbhat@marvell.com,
        huxinming820@gmail.com, solar@openwall.com, greg@kroah.com,
        kvalo@codeaurora.org, sashal@kernel.org, mrehak@redhat.com
Date:   Wed, 28 Aug 2019 22:37:49 +0200
In-Reply-To: <adff8812a50ca03f22fd0b3573a19ca42481c009.camel@sipsolutions.net> (sfid-20190828_223705_013504_4162F072)
References: <20190828020751.13625-1-huangwenabc@gmail.com>
         (sfid-20190828_040827_580483_8289AFC7) <adff8812a50ca03f22fd0b3573a19ca42481c009.camel@sipsolutions.net>
         (sfid-20190828_223705_013504_4162F072)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2019-08-28 at 22:36 +0200, Johannes Berg wrote:
> First of all, the subject doesn't make a lot of sense?

Ah, the whole thing is called under that function I guess, never mind

johannes

