Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40714 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S937229AbdAIMoI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jan 2017 07:44:08 -0500
Message-ID: <1483965843.17582.37.camel@sipsolutions.net> (sfid-20170109_134540_498190_4AB81D36)
Subject: Re: [PATCH net-next] bridge: multicast to unicast
From: Johannes Berg <johannes@sipsolutions.net>
To: Linus =?ISO-8859-1?Q?L=FCssing?= <linus.luessing@c0d3.blue>
Cc: netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Michael Braun <michael-dev@fami-braun.de>
Date: Mon, 09 Jan 2017 13:44:03 +0100
In-Reply-To: <20170109124231.GA9086@otheros>
References: <20170102193214.31723-1-linus.luessing@c0d3.blue>
         <1483706872.4089.8.camel@sipsolutions.net> <20170107151530.GG3134@otheros>
         <1483949149.17582.1.camel@sipsolutions.net> <20170109124231.GA9086@otheros>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> >          A host SHOULD silently discard a datagram that is received via
> >          a link-layer broadcast (see Section 2.4) but does not specify
> >          an IP multicast or broadcast destination address.
> 
> This example is the other way round. It specifies how the IP
> destination should look like in case of link-layer broadcast. Not
> how the link-layer destination should look like in case of a
> multicast/broadcast IP destination.

You stopped reading too early - snipped the context part for you :)

johannes
