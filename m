Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:51784 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751154AbcJ2S54 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 29 Oct 2016 14:57:56 -0400
Date: Sat, 29 Oct 2016 14:57:54 -0400 (EDT)
Message-Id: <20161029.145754.728917225207338115.davem@davemloft.net> (sfid-20161029_205802_415718_87BA77AC)
To: tgraf@suug.ch
Cc: johannes@sipsolutions.net, daniel@iogearbox.net,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH net-next] netlink: Add nla_memdup() to wrap kmemdup()
 use on nlattr
From: David Miller <davem@davemloft.net>
In-Reply-To: <2d0864c85200f1b42b1ebceee7c2dc60fe29f26a.1477471562.git.tgraf@suug.ch>
References: <2d0864c85200f1b42b1ebceee7c2dc60fe29f26a.1477471562.git.tgraf@suug.ch>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Thomas Graf <tgraf@suug.ch>
Date: Wed, 26 Oct 2016 10:53:16 +0200

> Wrap several common instances of:
> 	kmemdup(nla_data(attr), nla_len(attr), GFP_KERNEL);
> 
> Signed-off-by: Thomas Graf <tgraf@suug.ch>

Applied.
