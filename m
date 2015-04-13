Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:54428 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050AbbDMUfu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2015 16:35:50 -0400
Date: Mon, 13 Apr 2015 16:35:47 -0400 (EDT)
Message-Id: <20150413.163547.977591531353530005.davem@davemloft.net> (sfid-20150413_223637_686662_61E94A05)
To: richard@nod.at
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org, sameo@linux.intel.com,
	aloisio.almeida@openbossa.org, lauro.venancio@openbossa.org,
	kadlec@blackhole.kfki.hu, kaber@trash.net, pablo@netfilter.org
Subject: Re: [PATCH 4/5 v4] netfilter: Fix format string of nfnetlink_queue
 proc file
From: David Miller <davem@davemloft.net>
In-Reply-To: <1428879159-19237-4-git-send-email-richard@nod.at>
References: <1428879159-19237-1-git-send-email-richard@nod.at>
	<1428879159-19237-4-git-send-email-richard@nod.at>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Richard Weinberger <richard@nod.at>
Date: Mon, 13 Apr 2015 00:52:38 +0200

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

Applied.
