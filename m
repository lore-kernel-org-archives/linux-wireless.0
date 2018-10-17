Return-Path: <SRS0=hbYo=M5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3842ECDE3B
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 21:08:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C164208E4
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 21:08:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C164208E4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbeJRFGN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Oct 2018 01:06:13 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:51754 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbeJRFGN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Oct 2018 01:06:13 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gCt3Z-0002I0-EA; Wed, 17 Oct 2018 23:08:41 +0200
Message-ID: <adce5e0112ad8f811fcfa210c799605e45f6f1bc.camel@sipsolutions.net>
Subject: Re: [PATCH v2 1/2] mac80211_hwsim: allow setting iftype support
From:   Johannes Berg <johannes@sipsolutions.net>
To:     James Prestwood <james.prestwood@linux.intel.com>,
        linux-wireless@vger.kernel.org
Date:   Wed, 17 Oct 2018 23:08:27 +0200
In-Reply-To: <db2eb355abb871a97f5d342d1827e72dfa351e4d.camel@linux.intel.com>
References: <20181017193307.1780-1-james.prestwood@linux.intel.com>
         <20181017193307.1780-2-james.prestwood@linux.intel.com>
         (sfid-20181017_212933_830456_E841649D) <48e12e055637af139094b6c1163f61c45b5ebb54.camel@sipsolutions.net>
         <d7b8072e7648942738cac427b0b1f7005befc0c5.camel@linux.intel.com>
         <59ef2a794c49a6afdb5606f17b3cdc7c44594498.camel@sipsolutions.net>
         <db2eb355abb871a97f5d342d1827e72dfa351e4d.camel@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


> Ah ok, that makes sense. Ok, well I can fixup that typo, as well as
> reordering the use_chanctx stuff I mentioned. Unless there was anything
> else? If not I can submit v3.

I haven't really looked at it much yet, it's 11pm here and I'm tired :-)

Feel free to resubmit, but I'm not going to promise I won't make you
submit v4 if you do ;-)

johannes

