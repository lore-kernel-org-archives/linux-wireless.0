Return-Path: <SRS0=fa1V=77=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4062C433DF
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Jun 2020 13:48:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9181D20885
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Jun 2020 13:48:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728821AbgFRNsZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Jun 2020 09:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728159AbgFRNsZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Jun 2020 09:48:25 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE115C0613EE
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jun 2020 06:48:24 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jlutu-007jMr-W5; Thu, 18 Jun 2020 15:48:19 +0200
Message-ID: <d57c8bf64d6ea2e3f7355c2f7ca9b376db7fe21c.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Send deauth to STA's upon AP stop
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Shay Bar <shay.bar@celeno.com>
Cc:     linux-wireless@vger.kernel.org
Date:   Thu, 18 Jun 2020 15:48:17 +0200
In-Reply-To: <20200618093609.16514-1-shay.bar@celeno.com> (sfid-20200618_113627_790574_4007E613)
References: <20200618093609.16514-1-shay.bar@celeno.com>
         (sfid-20200618_113627_790574_4007E613)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2020-06-18 at 12:36 +0300, Shay Bar wrote:
> In current code, AP is not informing STA when its going down.
> 
Hostapd normally handles that. Are we really so worried about it
crashing?

johannes

