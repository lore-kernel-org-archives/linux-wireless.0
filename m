Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41106 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751175AbdALJdr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jan 2017 04:33:47 -0500
Message-ID: <1484212414.5391.2.camel@sipsolutions.net> (sfid-20170112_103423_552833_3BA5AAC1)
Subject: Re: [PATCH] wext: handle NULL exta data in iwe_stream_add_point
 better
From: Johannes Berg <johannes@sipsolutions.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Date: Thu, 12 Jan 2017 10:13:34 +0100
In-Reply-To: <1484210226.5391.1.camel@sipsolutions.net> (sfid-20170112_093730_369726_BDB087EE)
References: <20170111143532.485827-1-arnd@arndb.de>
         <CAK8P3a2mOT=BG=9yxJ1e-q__5FYq6dfF3t3bT1vqcgFaQAUjog@mail.gmail.com>
         <1484147177.29931.14.camel@sipsolutions.net> <3292373.oxnXTOSWCQ@wuerfel>
         <1484210226.5391.1.camel@sipsolutions.net>
         (sfid-20170112_093730_369726_BDB087EE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Come to think of it, I'm thinking I should drop this patch and the
> driver should just use iwe_stream_add_event() instead? It'll be
> somewhat tricky to get the length correct though.

No, turns out that's basically impossible with all the compat etc.
stuff here.

johannes
