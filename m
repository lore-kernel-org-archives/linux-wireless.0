Return-Path: <SRS0=iPli=OC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 584CEC43441
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 19:13:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E75720863
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 19:13:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1E75720863
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731618AbeKXF7F (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 24 Nov 2018 00:59:05 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:53424 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728243AbeKXF7E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Nov 2018 00:59:04 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gQGtN-0003hh-9V; Fri, 23 Nov 2018 20:13:29 +0100
Message-ID: <35140c078e15b5e54be4a9efe3e69ea53c6007e2.camel@sipsolutions.net>
Subject: Re: mac80211_hwsim: multiple antennas
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ramon Fontes <ramonreisfontes@gmail.com>
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 23 Nov 2018 20:13:27 +0100
In-Reply-To: <CAK8U23Y_xFK7ajBbTJ0kWKZnhdEkmRgd=9kmfcB1sztNyHxHEQ@mail.gmail.com> (sfid-20181121_141000_433292_B5542C49)
References: <CAK8U23bW5ov=FfD0xBnio7FwS9NTjoyewfHWZhHAmZNPsA16Jw@mail.gmail.com>
         <a88ba8b1e23b5e461f492f050cfd67c0222cf662.camel@sipsolutions.net>
         <CAK8U23Yi-wa0yT_K2eazTBEsVH3kmYHpZEeMmoDEAdyamdSTqA@mail.gmail.com>
         <7adcf11c634f31032eaac3c15f8d92b366f14477.camel@sipsolutions.net>
         <CAK8U23a8CMgNboStufh7kVpKSE9URkniWkpeNXi2hr1D3GunZQ@mail.gmail.com>
         <4fa8dc82a0c64bc5521fd0aacaa9bf951984d81e.camel@sipsolutions.net>
         <CAK8U23Y_xFK7ajBbTJ0kWKZnhdEkmRgd=9kmfcB1sztNyHxHEQ@mail.gmail.com>
         (sfid-20181121_141000_433292_B5542C49)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2018-11-21 at 10:09 -0300, Ramon Fontes wrote:
> Yes. I thought that it could be related to the number of antennas (or
> something else) after seeing this result
> (https://bobcopeland.com/blog/2014/09/wmediumd-speed-test/) provided
> by wmediumd.

I guess you should instead look at the code referenced by Bob in the
next post?

https://bobcopeland.com/blog/2014/11/functional-bitrate-sim/

johannes

