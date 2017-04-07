Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51864 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933390AbdDGTaF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Apr 2017 15:30:05 -0400
Message-ID: <1491593399.5800.14.camel@sipsolutions.net> (sfid-20170407_213042_039119_9124CCA1)
Subject: Re: [RFC 0/3] netlink: extended error reporting
From: Johannes Berg <johannes@sipsolutions.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Fri, 07 Apr 2017 21:29:59 +0200
In-Reply-To: <20170407192714.GA23349@salvia>
References: <1491591552.5800.1.camel@sipsolutions.net>
         <20170407190601.GA22991@salvia> <1491592185.5800.7.camel@sipsolutions.net>
         <20170407.122223.385211483743191711.davem@davemloft.net>
         <20170407192714.GA23349@salvia>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-04-07 at 21:27 +0200, Pablo Neira Ayuso wrote:
> 
> > Also another way to look at this is that we're providing a lot of
> > new power and expressability.  So even if only one aspect of the
> > new error reporting is used it's a positive step forward.

True.

> > So allow offset "0" meaning "unspecified".
> 
> Instead, we can just not send the offset attribute to userspace if
> it's not specified. So missing attribute means "unspecified".
> 
> I'm always a bit worried this "0 means something" semantics :)

Yeah, I have that. If it's 0 internally the attribute will be omitted.

johannes
