Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6C9AC282D8
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 21:54:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC24320823
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 21:54:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbfBAVyN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 16:54:13 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:50224 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbfBAVyN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 16:54:13 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gpglH-0007a9-AZ; Fri, 01 Feb 2019 22:54:11 +0100
Message-ID: <2d274e00c3e15e9786ccc865215d9853a5ab30f0.camel@sipsolutions.net>
Subject: Re: iw release cadence?
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Brian Norris <briannorris@chromium.org>
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 01 Feb 2019 22:54:08 +0100
In-Reply-To: <CA+ASDXMVAP4CsE=vaomOn5mu_uAM0jc3jvWGzaVPFFif4kTX+Q@mail.gmail.com> (sfid-20190201_224721_483652_2A0C6676)
References: <CA+ASDXMVAP4CsE=vaomOn5mu_uAM0jc3jvWGzaVPFFif4kTX+Q@mail.gmail.com>
         (sfid-20190201_224721_483652_2A0C6676)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Brian,

> Is there any sort of release cadence to the iw tool? Or is it pretty
> arbitrary? 

It's completely arbitrary. I tried to follow kernel releases, but as you
can see I just haven't kept up ...

> I'm curious, since it's been more than a year since the
> "v4.14" release. I'd like to package up bugfixes and a few features,
> but it'd be much nicer to just pull a new official tag/tarball than to
> drop a bunch of individual patches into my build system. If you're
> going to tag something soon though, I can...just wait for you :)
> 
> More bluntly: can I haz release please?

Sure!

I'll just tag one now :-)

johannes

