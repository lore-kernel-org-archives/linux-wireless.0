Return-Path: <SRS0=1Ud/=BJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9670CC433DF
	for <linux-wireless@archiver.kernel.org>; Thu, 30 Jul 2020 11:27:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BCD42074B
	for <linux-wireless@archiver.kernel.org>; Thu, 30 Jul 2020 11:27:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgG3L1q (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 30 Jul 2020 07:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbgG3L1q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Jul 2020 07:27:46 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61449C061794
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2020 04:27:46 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1k16iu-00DUYH-NI; Thu, 30 Jul 2020 13:27:44 +0200
Message-ID: <07f23c8856630c866751891c18f0709eb3d1f3f7.camel@sipsolutions.net>
Subject: Re: [PATCH v2 1/2] cfg80211: add helper fn for single rule channels
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Markus Theil <markus.theil@tu-ilmenau.de>
Cc:     linux-wireless@vger.kernel.org
Date:   Thu, 30 Jul 2020 13:27:27 +0200
In-Reply-To: <20200701101502.531240-1-markus.theil@tu-ilmenau.de>
References: <20200701101502.531240-1-markus.theil@tu-ilmenau.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4 (3.36.4-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,


> +
> +	handle_channel_single_rule(wiphy, initiator, chan, flags, lr, request_wiphy, reg_rule);

Even if checkpatch probably stopped warning, please don't create
gratuitously long lines. 80 columns is still something to aim for. This
can easily be broken into two or three.

Same applies to the second patch.

johannes

