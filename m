Return-Path: <SRS0=oODW=OA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CF1BC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 12:48:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F54221479
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 12:48:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2F54221479
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbeKUXW6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Nov 2018 18:22:58 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:43674 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726172AbeKUXW6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Nov 2018 18:22:58 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gPRvu-0003qk-Kh; Wed, 21 Nov 2018 13:48:42 +0100
Message-ID: <4fa8dc82a0c64bc5521fd0aacaa9bf951984d81e.camel@sipsolutions.net>
Subject: Re: mac80211_hwsim: multiple antennas
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ramon Fontes <ramonreisfontes@gmail.com>
Cc:     linux-wireless@vger.kernel.org
Date:   Wed, 21 Nov 2018 13:48:41 +0100
In-Reply-To: <CAK8U23a8CMgNboStufh7kVpKSE9URkniWkpeNXi2hr1D3GunZQ@mail.gmail.com> (sfid-20181121_134750_322815_C47C3291)
References: <CAK8U23bW5ov=FfD0xBnio7FwS9NTjoyewfHWZhHAmZNPsA16Jw@mail.gmail.com>
         <a88ba8b1e23b5e461f492f050cfd67c0222cf662.camel@sipsolutions.net>
         <CAK8U23Yi-wa0yT_K2eazTBEsVH3kmYHpZEeMmoDEAdyamdSTqA@mail.gmail.com>
         <7adcf11c634f31032eaac3c15f8d92b366f14477.camel@sipsolutions.net>
         <CAK8U23a8CMgNboStufh7kVpKSE9URkniWkpeNXi2hr1D3GunZQ@mail.gmail.com>
         (sfid-20181121_134750_322815_C47C3291)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2018-11-21 at 09:47 -0300, Ramon Fontes wrote:
> Okay! Thanks a lot.
> 
> Indeed, the maximum throughput when using only hwsim is in the order of Gbp/s.

So I guess the question is where it's going wrong - is it the wmediumd
overhead (netlink), some air simulation in wmediumd, etc.

johannes

