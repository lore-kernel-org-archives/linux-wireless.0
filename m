Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:54405 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbbDMUfb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2015 16:35:31 -0400
Date: Mon, 13 Apr 2015 16:35:29 -0400 (EDT)
Message-Id: <20150413.163529.25460892277772842.davem@davemloft.net> (sfid-20150413_223739_123323_6413C465)
To: richard@nod.at
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org, sameo@linux.intel.com,
	aloisio.almeida@openbossa.org, lauro.venancio@openbossa.org,
	kadlec@blackhole.kfki.hu, kaber@trash.net, pablo@netfilter.org
Subject: Re: [PATCH 1/5 v4] netlink: Fix portid type in netlink_notify
From: David Miller <davem@davemloft.net>
In-Reply-To: <1428879159-19237-1-git-send-email-richard@nod.at>
References: <1428879159-19237-1-git-send-email-richard@nod.at>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Richard Weinberger <richard@nod.at>
Date: Mon, 13 Apr 2015 00:52:35 +0200

> portid is an unsigned integer. Fix netlink_notify to
> match all other portid user in the kernel.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

Applied.
