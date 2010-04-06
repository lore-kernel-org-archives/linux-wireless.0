Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39409 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756438Ab0DFVPN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Apr 2010 17:15:13 -0400
Date: Tue, 6 Apr 2010 17:02:28 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-wireless@vger.kernel.org, buytenh@wantstofly.org
Subject: Re: [PATCH] mwl8k: use the dma state API instead of the pci
	equivalents
Message-ID: <20100406210228.GD3017@tuxdriver.com>
References: <20100402130828O.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100402130828O.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 02, 2010 at 01:10:38PM +0900, FUJITA Tomonori wrote:
> The DMA API is preferred.
> 
> No functional change.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Again, what tree is this against?  mwl8k fails to build after this patch.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
