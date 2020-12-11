Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0104DC433FE
	for <linux-wireless@archiver.kernel.org>; Fri, 11 Dec 2020 12:24:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBB1823EB3
	for <linux-wireless@archiver.kernel.org>; Fri, 11 Dec 2020 12:24:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395551AbgLKMYF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 11 Dec 2020 07:24:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388412AbgLKMXc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Dec 2020 07:23:32 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA2EFC0613CF
        for <linux-wireless@vger.kernel.org>; Fri, 11 Dec 2020 04:22:51 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1knhRg-006lp3-AY; Fri, 11 Dec 2020 13:22:48 +0100
Message-ID: <7a770c592cb2d3ae5ed9dab19c515b139818b05d.camel@sipsolutions.net>
Subject: Re: [PATCH v3 v3] mac80211: 160MHz support per IEEE802.11ax standard
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Shay Bar <shay.bar@celeno.com>
Cc:     linux-wireless@vger.kernel.org, aviad.brikman@celeno.com,
        eliav.farber@celeno.com
Date:   Fri, 11 Dec 2020 13:22:32 +0100
In-Reply-To: <4e7d4c76-93a5-0863-bffa-897183bfb4fb@celeno.com>
References: <20201019063921.4335-1-shay.bar@celeno.com>
         <20201019132616.32286-1-shay.bar@celeno.com>
         <9a043fdcf1c6324688f4c92b18f31c267969f5fc.camel@sipsolutions.net>
         <4f38e1cf-fc8c-c9fd-e064-e433a8b82186@celeno.com>
         <84e63d2b334b8dbfb2de23f604030c7ea355444d.camel@sipsolutions.net>
         <4e7d4c76-93a5-0863-bffa-897183bfb4fb@celeno.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, 2020-11-15 at 10:57 +0200, Shay Bar wrote:
> 
> This is the source of confusion, sorry :)

Actually, the confusion is that you said "160 MHz support" ... and you
really only meant "160 MHz in extended channel switch" :-)

I'll respond to the patch also again.

johannes

