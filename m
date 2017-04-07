Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52156 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932800AbdDGTrr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Apr 2017 15:47:47 -0400
Message-ID: <1491594459.5800.19.camel@sipsolutions.net> (sfid-20170407_214852_884176_77C84DEB)
Subject: Re: [RFC 0/3] netlink: extended error reporting
From: Johannes Berg <johannes@sipsolutions.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Date: Fri, 07 Apr 2017 21:47:39 +0200
In-Reply-To: <20170407194557.GA23613@salvia>
References: <20170407182620.6438-1-johannes@sipsolutions.net>
         <20170407.115315.23470877439489670.davem@davemloft.net>
         <1491591552.5800.1.camel@sipsolutions.net> <20170407190601.GA22991@salvia>
         <1491592185.5800.7.camel@sipsolutions.net> <20170407192134.GA23205@salvia>
         <1491593357.5800.13.camel@sipsolutions.net> <20170407194557.GA23613@salvia>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-04-07 at 21:45 +0200, Pablo Neira Ayuso wrote:
> 
> We only need to store the pointer to the attribute in the error
> container structure. We can calculate the offset from nl_err() by
> pasing the skbuff as parameter there, right?

Ah, that's a good point, we could store the nlattr pointer and
calculate the offset later. I'll need to try this, but yeah, good idea!

johannes
