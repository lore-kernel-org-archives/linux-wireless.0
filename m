Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49816 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754039AbdAJK4M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Jan 2017 05:56:12 -0500
Message-ID: <1484045763.1014.0.camel@sipsolutions.net> (sfid-20170110_115640_475058_0F08C92D)
Subject: Re: [PATCH net-next] bridge: multicast to unicast
From: Johannes Berg <johannes@sipsolutions.net>
To: Linus =?ISO-8859-1?Q?L=FCssing?= <linus.luessing@c0d3.blue>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc: "M. Braun" <michael-dev@fami-braun.de>,
        Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Date: Tue, 10 Jan 2017 11:56:03 +0100
In-Reply-To: <20170110041816.GJ5513@otheros>
References: <20170102193214.31723-1-linus.luessing@c0d3.blue>
         <1483706872.4089.8.camel@sipsolutions.net>
         <8836daaa-9638-4502-d079-fd428595f822@nbd.name>
         <1483710841.12677.1.camel@sipsolutions.net>
         <22fad045-57c6-7789-d19f-f47bd0faf441@fami-braun.de>
         <20170107145516.GE3134@otheros> <1483949336.17582.3.camel@sipsolutions.net>
         <6f5ec9f1-800a-2bc4-2f41-9d803343bb22@fami-braun.de>
         <20170109212345.GA5513@otheros> <20170109133032.221f8669@xeon-e3>
         <20170110041816.GJ5513@otheros>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-01-10 at 05:18 +0100, Linus Lüssing wrote:
> On Mon, Jan 09, 2017 at 01:30:32PM -0800, Stephen Hemminger wrote:
> > I wonder if MAC80211 should be doing IGMP snooping and not bridge
> > in this environment.
> 
> In the long term, yes. For now, not quite sure.

There's no "for now" in the kernel. Code added now will have to be
maintained essentially forever.

johannes
