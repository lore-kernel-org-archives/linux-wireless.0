Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34129 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754623AbbDMSjR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2015 14:39:17 -0400
Date: Mon, 13 Apr 2015 20:43:34 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Richard Weinberger <richard@nod.at>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org, sameo@linux.intel.com,
	aloisio.almeida@openbossa.org, lauro.venancio@openbossa.org,
	davem@davemloft.net, kadlec@blackhole.kfki.hu, kaber@trash.net
Subject: Re: [PATCH 4/5 v4] netfilter: Fix format string of nfnetlink_queue
 proc file
Message-ID: <20150413184334.GB3333@salvia> (sfid-20150413_204022_515741_E3124B42)
References: <1428879159-19237-1-git-send-email-richard@nod.at>
 <1428879159-19237-4-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1428879159-19237-4-git-send-email-richard@nod.at>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 13, 2015 at 12:52:38AM +0200, Richard Weinberger wrote:
> The printed values are all of type unsigned integer, therefore use
> %u instead of %d. Otherwise an user can face negative values.
> 
> Fixes:
> $ cat /proc/net/netfilter/nfnetlink_queue
>     0  29508   278 2 65531     0 2004213241 -2129885586  1
>     1 -27747     0 2 65531     0     0        0  1
>     2 -27748     0 2 65531     0     0        0  1
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
