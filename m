Return-Path: <SRS0=Sl5Z=XU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53903C432C2
	for <linux-wireless@archiver.kernel.org>; Wed, 25 Sep 2019 20:12:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B5362146E
	for <linux-wireless@archiver.kernel.org>; Wed, 25 Sep 2019 20:12:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392921AbfIYUMH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 25 Sep 2019 16:12:07 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:60104 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731062AbfIYUMH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Sep 2019 16:12:07 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iDDdt-0004Vl-S6; Wed, 25 Sep 2019 22:12:06 +0200
Message-ID: <eeb9aec02f195dd9586aaeff7903b01f7ff904d7.camel@sipsolutions.net>
Subject: Re: Virtual interfaces intel AX200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Bruno Antunes <baantunes@gmail.com>, linux-wireless@vger.kernel.org
Date:   Wed, 25 Sep 2019 22:12:03 +0200
In-Reply-To: <CABUTiXX6D=Hoaue2pLPvctdQy2Pv_Pdjj2ysXp5QE3138DTZEw@mail.gmail.com> (sfid-20190920_173448_526464_42707D15)
References: <CABUTiXX6D=Hoaue2pLPvctdQy2Pv_Pdjj2ysXp5QE3138DTZEw@mail.gmail.com>
         (sfid-20190920_173448_526464_42707D15)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2019-09-20 at 16:34 +0100, Bruno Antunes wrote:
> Hello,
> 
> Does anyone knows if the new intel AX200 or intel AX201 have support
> for multiple virtual interfaces?
> Is there any intel Wi-Fi device that does support it?

TBH I'm not really sure what exactly it does now, but the driver does
contain code to advertise the limits.

I think it's basically P2P + normal client.

johannes

