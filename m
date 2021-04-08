Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ABC9C433ED
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Apr 2021 14:42:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1212B610F8
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Apr 2021 14:42:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbhDHOm2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Apr 2021 10:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231480AbhDHOmZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Apr 2021 10:42:25 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88992C061760;
        Thu,  8 Apr 2021 07:42:14 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lUVrI-0092ie-51; Thu, 08 Apr 2021 16:42:12 +0200
Message-ID: <f37b7a2e1f6e0348799fa3dfd0845e67fa0ebd81.camel@sipsolutions.net>
Subject: Re: pull-request: mac80211 2021-04-08
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Date:   Thu, 08 Apr 2021 16:42:10 +0200
In-Reply-To: <20210408125344.50279-1-johannes@sipsolutions.net> (sfid-20210408_145352_855056_807E3D7B)
References: <20210408125344.50279-1-johannes@sipsolutions.net>
         (sfid-20210408_145352_855056_807E3D7B)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2021-04-08 at 14:53 +0200, Johannes Berg wrote:
> Hi,
> 
> Yes, I'm late with this, sorry about that. I've mostly restricted this
> to the most necessary fixes, though the virt_wifi one isn't but since
> that's not used a lot, it's harmless and included since it's obvious.
> 
> The only thing that's bigger is the rfkill thing, but that's just since
> it adds a new version of the struct for userspace to use, since the
> change to the existing struct caused various breakage all around.

Wait, let me withdraw that - I have another syzbot fix coming.

johannes

