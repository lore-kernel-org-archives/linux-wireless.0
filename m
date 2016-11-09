Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33492 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751919AbcKIVFt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Nov 2016 16:05:49 -0500
Message-ID: <1478725543.21403.4.camel@sipsolutions.net> (sfid-20161109_220552_621364_AFFA90AE)
Subject: Re: [RFC] qtn: add FullMAC firmware for Quantenna QSR10G wifi device
From: Johannes Berg <johannes@sipsolutions.net>
To: IgorMitsyanko <igor.mitsyanko.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org, btherthala@quantenna.com,
        hwang@quantenna.com, smaksimenko@quantenna.com,
        dlebed@quantenna.com, Igor Mitsyanko <imitsyanko@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Date: Wed, 09 Nov 2016 22:05:43 +0100
In-Reply-To: <2fcb5f28-808e-f296-7e91-e5185e7577c9@quantenna.com>
References: <1478700000-11624-1-git-send-email-igor.mitsyanko.os@quantenna.com>
         <1478706966.18306.1.camel@sipsolutions.net>
         <2fcb5f28-808e-f296-7e91-e5185e7577c9@quantenna.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > With the carl9170 driver, the GPL firmware was required to be put
> > as buildable source code into the linux-firmware tree.

> An SDK that can be used to build QSR10G firmware is a ~240MB file in
> compressed archive format, it includes GPL code as well as
> proprietary components.
> Our legal team included following clause in licence file coming with
> firmware:
> Information regarding the Open Source Components included with the
> Software is available upon request to oslegal@quantenna.com
> So the idea is that GPL components used in firmware can be provided
> on request.

I understand, and I understand that you/they are actually providing it
when asked.

However, the carl9170 project has its (entirely GPL) source tree out in
the open, making it much *easier* and that was *still* thought to not
be sufficient; I don't recall the discussions but I'm guessing that's
because of something like redistributors having to make sure source is
available, and guaranteeing that for a long time, etc.

johannes
