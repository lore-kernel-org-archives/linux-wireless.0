Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33308 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1764175AbdAKPGW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 10:06:22 -0500
Message-ID: <1484147177.29931.14.camel@sipsolutions.net> (sfid-20170111_160720_236035_2E1EA5EF)
Subject: Re: [PATCH] wext: handle NULL exta data in iwe_stream_add_point
 better
From: Johannes Berg <johannes@sipsolutions.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Date: Wed, 11 Jan 2017 16:06:17 +0100
In-Reply-To: <CAK8P3a2mOT=BG=9yxJ1e-q__5FYq6dfF3t3bT1vqcgFaQAUjog@mail.gmail.com> (sfid-20170111_160001_614546_326AFA12)
References: <20170111143532.485827-1-arnd@arndb.de>
         <1484145522.29931.13.camel@sipsolutions.net>
         <CAK8P3a2mOT=BG=9yxJ1e-q__5FYq6dfF3t3bT1vqcgFaQAUjog@mail.gmail.com>
         (sfid-20170111_160001_614546_326AFA12)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-01-11 at 16:00 +0100, Arnd Bergmann wrote:
> On Wed, Jan 11, 2017 at 3:38 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Wed, 2017-01-11 at 15:35 +0100, Arnd Bergmann wrote:
> > > This works fine here because iwe->u.data.length is guaranteed to
> > > be
> > > NULL, and the memcpy doesn't actually have an effect.
> > 
> > I think you mean 0, not NULL, but I can fix that when I apply it.
> 
> Right, thanks!

Applied. Also fixed the typo in the subject :)

johannes
