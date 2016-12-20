Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55726 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751245AbcLTHrM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Dec 2016 02:47:12 -0500
Message-ID: <1482220026.16460.0.camel@sipsolutions.net> (sfid-20161220_084823_294700_E570CC91)
Subject: Re: "rfkill: Add rfkill-any LED trigger" causes deadlock
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Micha=C5=82_K=C4=99pie=C5=84?= <kernel@kempniu.pl>
Cc: =?UTF-8?Q?=D0=9C=D0=B8=D1=85=D0=B0=D0=B8=D0=BB_?=
         =?UTF-8?Q?=D0=9A=D1=80=D0=B8=D0=BD=D0=BA=D0=B8=D0=BD?=
        <krinkin.m.u@gmail.com>, linux-wireless@vger.kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org
Date: Tue, 20 Dec 2016 08:47:06 +0100
In-Reply-To: <20161219140115.GA18194@kmp-mobile.hq.kempniu.pl> (sfid-20161219_150121_414538_6E38332A)
References: <20161216163707.GA2629@gmail.com>
         <CACpa5=_chGuU3zVcVR3nkNySwz1cGAQTs39v+BjwcDNSvOqhTw@mail.gmail.com>
         <1482137772.31461.1.camel@sipsolutions.net>
         <20161219140115.GA18194@kmp-mobile.hq.kempniu.pl>
         (sfid-20161219_150121_414538_6E38332A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Just to ensure things get cleaned up properly, as of now it looks
> like you only reverted patch 2/2 of my v2 and Arnd's fix to patch
> 1/2, not patch 1/2 itself.

Oops. I've fixed that up to only revert your patch - I wanted the
revert in the tree to document the issue, rather than just dropping the
patch entirely. Thanks for noticing that mistake.

johannes
