Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43395 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759597Ab2EWKqk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 May 2012 06:46:40 -0400
Date: Wed, 23 May 2012 12:45:47 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linville@tuxdriver.com,
	netfilter-devel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [README] Two merges pending...
Message-ID: <20120523104547.GA3312@1984> (sfid-20120523_124644_047471_A8F56720)
References: <20120522.152840.815291543305899477.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120522.152840.815291543305899477.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi David,

On Tue, May 22, 2012 at 03:28:40PM -0400, David Miller wrote:
[...]
> Pablo also has a prearranged netfilter merge pending.

I give up on that merge that I requested.

I thought that some namespace changes for conntrack that have been
lying on the table for one week could be merged. But they are not ready
yet, they require another spin.

That means they'll have to wait until window opens again, they need
some extra time.

I'll stick to one pull request for bugfixes then.

Thanks!
