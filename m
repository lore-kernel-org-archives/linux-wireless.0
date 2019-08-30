Return-Path: <SRS0=jb13=W2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDBB3C3A5A4
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Aug 2019 10:48:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB2BB21897
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Aug 2019 10:48:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbfH3Kss (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 30 Aug 2019 06:48:48 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:34790 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726902AbfH3Kss (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Aug 2019 06:48:48 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.1)
        (envelope-from <johannes@sipsolutions.net>)
        id 1i3eSU-0004Fs-HR; Fri, 30 Aug 2019 12:48:46 +0200
Message-ID: <4a8b8815ba3530b6e0ec611c9579658a458cd522.camel@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: Convert 6 GHz channel frequency to channel
 number
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Amar Singhal <asinghal@codeaurora.org>, jouni@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, jjohnson@codeaurora.org,
        rmanohar@codeaurora.org
Date:   Fri, 30 Aug 2019 12:48:45 +0200
In-Reply-To: <b9520a71-2571-4334-65b8-8707159406aa@broadcom.com> (sfid-20190830_124746_755381_51D6A777)
References: <1567117290-19295-1-git-send-email-asinghal@codeaurora.org>
         <420dcc9c0023791b72dba2d776045fc0b025597a.camel@sipsolutions.net>
         <b9520a71-2571-4334-65b8-8707159406aa@broadcom.com>
         (sfid-20190830_124746_755381_51D6A777)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2019-08-30 at 12:47 +0200, Arend Van Spriel wrote:
> On 8/30/2019 12:32 PM, Johannes Berg wrote:
> > On Thu, 2019-08-29 at 15:21 -0700, Amar Singhal wrote:
> > > Enhance function ieee80211_frequency_to_channel by adding 6 GHz
> > > channels.
> > 
> > Wait, this is already supported, no? Just implemented slightly
> > differently?
> 
> It is Johannes, but I was unaware as well. Did you forget to email that 
> it was applied or is there some automated stuff that failed on you? ;-)

Truth be told, I've been very lazy (mostly due to being busy) and
haven't responded manually - and also haven't managed to set up anything
that would automate a response, I tried Kalle's tool at one point but it
didn't work for me yet.

Right now, your best bet is probably to poll patchwork, sorry about
that.

johannes

