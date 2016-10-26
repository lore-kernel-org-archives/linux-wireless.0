Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49920 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754620AbcJZI4b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 04:56:31 -0400
Message-ID: <1477472185.4059.22.camel@sipsolutions.net> (sfid-20161026_105651_716562_48B8B229)
Subject: Re: [PATCH net-next] netlink: Add nla_memdup() to wrap kmemdup()
 use on nlattr
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Graf <tgraf@suug.ch>, davem@davemloft.net
Cc: daniel@iogearbox.net, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Date: Wed, 26 Oct 2016 10:56:25 +0200
In-Reply-To: <2d0864c85200f1b42b1ebceee7c2dc60fe29f26a.1477471562.git.tgraf@suug.ch>
References: <2d0864c85200f1b42b1ebceee7c2dc60fe29f26a.1477471562.git.tgraf@suug.ch>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-10-26 at 10:53 +0200, Thomas Graf wrote:
> Wrap several common instances of:
> 	kmemdup(nla_data(attr), nla_len(attr), GFP_KERNEL);

Makes sense

Acked-by: Johannes Berg <johannes@sipsolutions.net>

johannes
