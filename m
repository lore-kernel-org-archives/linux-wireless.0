Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55707 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979AbZE2Kad (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 May 2009 06:30:33 -0400
Date: Fri, 29 May 2009 12:18:35 +0200
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/10]: rtl8187: Remove pointless check in
	rtl8187_rx_cb().
Message-ID: <20090529101834.GC3506@tuxdriver.com>
References: <20090529.014011.244789664.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090529.014011.244789664.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 29, 2009 at 01:40:11AM -0700, David Miller wrote:
> 
> First of all, it exposes the SKB list implementation.
> 
> Second of all it's not needed.  If we get called here, we
> successfully enqueued the URB with the linked SKB and
> such a completion only gets called one time on such an
> SKB.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>

ACK

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
