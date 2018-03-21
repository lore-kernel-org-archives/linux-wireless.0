Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:36632 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752237AbeCUN6N (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 09:58:13 -0400
Message-ID: <1521640687.2645.30.camel@sipsolutions.net> (sfid-20180321_145834_047696_08BB431C)
Subject: Re: [PATCH] mac80211: aes-cmac: remove VLA usage
From: Johannes Berg <johannes@sipsolutions.net>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 21 Mar 2018 14:58:07 +0100
In-Reply-To: <b367cf76-e6c5-3d6d-5d81-a68ae245e6b9@embeddedor.com>
References: <20180321134247.GA1275@embeddedgus>
         <1521640094.2645.29.camel@sipsolutions.net>
         <b367cf76-e6c5-3d6d-5d81-a68ae245e6b9@embeddedor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-03-21 at 08:57 -0500, Gustavo A. R. Silva wrote:
> 
> SHA_DESC_ON_STACK is currently being used in multiple places. But, yeah, 
> I think we can define multiple macros of the same kind and adjust to the 
> characteristics of each the component.
> 
> How big do you think tfm can get?

I have no idea, I guess you'll have to take that with Herbert.

johannes
