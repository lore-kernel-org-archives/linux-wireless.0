Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.aperture-lab.de ([138.201.29.205]:35078 "EHLO
        mail.aperture-lab.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937714AbdAJESW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jan 2017 23:18:22 -0500
Date: Tue, 10 Jan 2017 05:18:16 +0100
From: Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: "M. Braun" <michael-dev@fami-braun.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH net-next] bridge: multicast to unicast
Message-ID: <20170110041816.GJ5513@otheros> (sfid-20170110_051851_828008_CE1DE59A)
References: <20170102193214.31723-1-linus.luessing@c0d3.blue>
 <1483706872.4089.8.camel@sipsolutions.net>
 <8836daaa-9638-4502-d079-fd428595f822@nbd.name>
 <1483710841.12677.1.camel@sipsolutions.net>
 <22fad045-57c6-7789-d19f-f47bd0faf441@fami-braun.de>
 <20170107145516.GE3134@otheros>
 <1483949336.17582.3.camel@sipsolutions.net>
 <6f5ec9f1-800a-2bc4-2f41-9d803343bb22@fami-braun.de>
 <20170109212345.GA5513@otheros>
 <20170109133032.221f8669@xeon-e3>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170109133032.221f8669@xeon-e3>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 09, 2017 at 01:30:32PM -0800, Stephen Hemminger wrote:
> I wonder if MAC80211 should be doing IGMP snooping and not bridge
> in this environment.

In the long term, yes. For now, not quite sure.

I personally like to go for simple solutions first :).
