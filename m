Return-Path: <SRS0=fa1V=77=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F534C433E0
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Jun 2020 14:38:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FD7F2083B
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Jun 2020 14:38:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730833AbgFROil (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Jun 2020 10:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726981AbgFROil (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Jun 2020 10:38:41 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63CEBC06174E
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jun 2020 07:38:41 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jlvgd-007keY-Ml; Thu, 18 Jun 2020 16:38:39 +0200
Message-ID: <54236bdd708c53ec2f2a776bb3badcd77c7fecc6.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Send deauth to STA's upon AP stop
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Shay Bar <Shay.Bar@celeno.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date:   Thu, 18 Jun 2020 16:38:38 +0200
In-Reply-To: <AM0P192MB0468CA3DA7C8EC62366AC04AE79B0@AM0P192MB0468.EURP192.PROD.OUTLOOK.COM>
References: <20200618093609.16514-1-shay.bar@celeno.com>
         (sfid-20200618_113627_790574_4007E613) <d57c8bf64d6ea2e3f7355c2f7ca9b376db7fe21c.camel@sipsolutions.net>
         <AM0P192MB04682E48D814F5F6CAFBF9CAE79B0@AM0P192MB0468.EURP192.PROD.OUTLOOK.COM>
         <2a7b33ace030fdeda96e60b2abd6c70a11f426e0.camel@sipsolutions.net>
         <AM0P192MB0468CA3DA7C8EC62366AC04AE79B0@AM0P192MB0468.EURP192.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2020-06-18 at 14:36 +0000, Shay Bar wrote:
> > We're doing that. More accurately, hostapd is doing that. So what's not
> > working for you?
> > johannes
> 
> Air capture shows, hostapd doesn’t send deauth in the below 2 cases and I
> actually don't see such hostapd code that handles that:
> "ifconfig <if> down"
> "killall hostapd"

So... why would you ever do that? :)

johannes

