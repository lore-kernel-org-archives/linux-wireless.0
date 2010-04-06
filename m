Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41342 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756721Ab0DFVAM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Apr 2010 17:00:12 -0400
Date: Tue, 6 Apr 2010 16:58:18 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: yi.zhu@intel.com, reinette.chatre@intel.com, ilw@linux.intel.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: use the dma state API instead of the pci
	equivalents
Message-ID: <20100406205818.GC3017@tuxdriver.com>
References: <20100402131008B.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100402131008B.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 02, 2010 at 01:10:39PM +0900, FUJITA Tomonori wrote:
> The DMA API is preferred.
> 
> No functional change.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

What tree is this against?  It doesn't seem to apply against the
current iwlwifi bits and it seems to miss some pci_* stuff at the
same time.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
