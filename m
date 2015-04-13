Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34083 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754309AbbDMSjC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2015 14:39:02 -0400
Date: Mon, 13 Apr 2015 20:43:19 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Richard Weinberger <richard@nod.at>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org, sameo@linux.intel.com,
	aloisio.almeida@openbossa.org, lauro.venancio@openbossa.org,
	davem@davemloft.net, kadlec@blackhole.kfki.hu, kaber@trash.net
Subject: Re: [PATCH 3/5 v4] netfilter: Fix portid types
Message-ID: <20150413184319.GA3333@salvia> (sfid-20150413_204031_893512_35E6DE97)
References: <1428879159-19237-1-git-send-email-richard@nod.at>
 <1428879159-19237-3-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1428879159-19237-3-git-send-email-richard@nod.at>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 13, 2015 at 12:52:37AM +0200, Richard Weinberger wrote:
> The netlink portid is an unsigned integer, use this type
> also in netfilter.
>
> Signed-off-by: Richard Weinberger <richard@nod.at>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
