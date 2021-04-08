Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA3ACC43462
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Apr 2021 13:26:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6466E6113C
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Apr 2021 13:26:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbhDHN0Z (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Apr 2021 09:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbhDHN0U (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Apr 2021 09:26:20 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B70E3C061761
        for <linux-wireless@vger.kernel.org>; Thu,  8 Apr 2021 06:26:08 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lUUff-0090yD-12; Thu, 08 Apr 2021 15:26:07 +0200
Message-ID: <9282f2d2c6c8302de0c53dfb90743bd97e5a5a32.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Enable power save after receiving NULL packet
 ACK
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Bassem Dawood <bassem@morsemicro.com>,
        linux-wireless@vger.kernel.org
Date:   Thu, 08 Apr 2021 15:26:06 +0200
In-Reply-To: <20210227055815.14838-1-bassem@morsemicro.com> (sfid-20210227_065951_509390_7AD34836)
References: <20210227055815.14838-1-bassem@morsemicro.com>
         (sfid-20210227_065951_509390_7AD34836)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, 2021-02-27 at 16:58 +1100, Bassem Dawood wrote:
> Trigger dynamic_ps_timer to re-evaluate power saving once a null function
> packet (with PM = 1) is ACKed.

Can you please say what this fixes/why the change is needed?

johannes

