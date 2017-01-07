Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:35291 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936590AbdAGDN7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jan 2017 22:13:59 -0500
Received: by mail-pg0-f53.google.com with SMTP id i5so192780584pgh.2
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jan 2017 19:13:59 -0800 (PST)
Date: Fri, 6 Jan 2017 19:13:56 -0800
From: Stephen Hemminger <stephen@networkplumber.org>
To: Linus =?UTF-8?B?TMO8c3Npbmc=?= <linus.luessing@c0d3.blue>
Cc: netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH net-next] bridge: multicast to unicast
Message-ID: <20170106191356.43740a26@xeon-e3> (sfid-20170107_041434_695334_095060C9)
In-Reply-To: <20170102193214.31723-1-linus.luessing@c0d3.blue>
References: <20170102193214.31723-1-linus.luessing@c0d3.blue>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon,  2 Jan 2017 20:32:14 +0100
Linus L=C3=BCssing <linus.luessing@c0d3.blue> wrote:

> This feature is intended for interface types which have a more reliable
> and/or efficient way to deliver unicast packets than broadcast ones
> (e.g. wifi).


Why is this not done in MAC80211 rather than  bridge?
