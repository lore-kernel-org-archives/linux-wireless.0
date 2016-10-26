Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:58797 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756418AbcJZI5t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 04:57:49 -0400
Message-ID: <58107008.2080907@iogearbox.net> (sfid-20161026_110233_107563_808F855B)
Date: Wed, 26 Oct 2016 10:57:44 +0200
From: Daniel Borkmann <daniel@iogearbox.net>
MIME-Version: 1.0
To: Thomas Graf <tgraf@suug.ch>, davem@davemloft.net
CC: johannes@sipsolutions.net, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH net-next] netlink: Add nla_memdup() to wrap kmemdup()
 use on nlattr
References: <2d0864c85200f1b42b1ebceee7c2dc60fe29f26a.1477471562.git.tgraf@suug.ch>
In-Reply-To: <2d0864c85200f1b42b1ebceee7c2dc60fe29f26a.1477471562.git.tgraf@suug.ch>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/26/2016 10:53 AM, Thomas Graf wrote:
> Wrap several common instances of:
> 	kmemdup(nla_data(attr), nla_len(attr), GFP_KERNEL);
>
> Signed-off-by: Thomas Graf <tgraf@suug.ch>

Thanks!

Acked-by: Daniel Borkmann <daniel@iogearbox.net>
