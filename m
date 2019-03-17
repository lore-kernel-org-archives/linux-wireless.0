Return-Path: <SRS0=pME5=RU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89BC6C43381
	for <linux-wireless@archiver.kernel.org>; Sun, 17 Mar 2019 22:38:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62F8920872
	for <linux-wireless@archiver.kernel.org>; Sun, 17 Mar 2019 22:38:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbfCQWi1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 17 Mar 2019 18:38:27 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:54656 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbfCQWi1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 17 Mar 2019 18:38:27 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1h5eQC-0006s0-2z; Sun, 17 Mar 2019 23:38:24 +0100
Message-ID: <d4db2ae373172afa8d2eb22e92a54a6f921784b7.camel@sipsolutions.net>
Subject: Re: [PATCH 5/5] mac80211_hwsim: Ext Key ID support (NATIVE)
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     linux-wireless@vger.kernel.org
Date:   Sun, 17 Mar 2019 23:38:23 +0100
In-Reply-To: <20190316204208.16497-6-alexander@wetzel-home.de>
References: <20190316204208.16497-1-alexander@wetzel-home.de>
         <20190316204208.16497-6-alexander@wetzel-home.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Since I'm travelling to netdev and all, I'm not sure I'll actually get
around to this patchset soon.

On Sat, 2019-03-16 at 21:42 +0100, Alexander Wetzel wrote:
> Driver is not supporting hardware encryption and therefore fully
> compatible with Extended Key ID.

On this particular patch now reading this I'm wondering if we shouldn't
just do that in mac80211 if there's no set_key callback? I suspect
that'd affect a few drivers that are otherwise more or less orphaned.

johannes

