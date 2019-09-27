Return-Path: <SRS0=tM6R=XW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F374C4360C
	for <linux-wireless@archiver.kernel.org>; Fri, 27 Sep 2019 12:35:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78D8A207FF
	for <linux-wireless@archiver.kernel.org>; Fri, 27 Sep 2019 12:35:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbfI0MfG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 27 Sep 2019 08:35:06 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:54476 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbfI0MfG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Sep 2019 08:35:06 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iDpSj-0007Zz-3M; Fri, 27 Sep 2019 14:35:05 +0200
Message-ID: <6d62fe25faca3c000964e4f712bf3ba2d974d2f2.camel@sipsolutions.net>
Subject: Re: mac80211_hwsim: packets being transmitted through the monitor
 interface
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ramon Fontes <ramonreisfontes@gmail.com>
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 27 Sep 2019 14:35:04 +0200
In-Reply-To: <CAK8U23bdmJGARCT=TXKyfknhmz-V0qUJ8dj0Mhko-CkvW+uW1A@mail.gmail.com> (sfid-20190927_143034_580324_D7D6C893)
References: <CAK8U23ZyFnYt+ePreGjFA2VFXnpu21SPthscvJhP-5xjQCb0OA@mail.gmail.com>
         <49ded6ae8a23c29168ab7061235292ac7a853e0f.camel@sipsolutions.net>
         <CAK8U23bdmJGARCT=TXKyfknhmz-V0qUJ8dj0Mhko-CkvW+uW1A@mail.gmail.com>
         (sfid-20190927_143034_580324_D7D6C893)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

[please quote properly]

On Fri, 2019-09-27 at 09:30 -0300, Ramon Fontes wrote:
> Yes, I agree that they are different things, but I can also see the
> packets through the monitor interface created via iw. Is this expected
> too?

The hwsim0 interface shows *all* packets on the virtual air.

A monitor interface created on one of the (hwsim or other!) wiphys shows
all packets seen by that device.

johannes

