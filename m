Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:45999 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243Ab0DGAfa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Apr 2010 20:35:30 -0400
To: linville@tuxdriver.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-wireless@vger.kernel.org,
	buytenh@wantstofly.org
Subject: Re: [PATCH] mwl8k: use the dma state API instead of the pci
	equivalents
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100406210228.GD3017@tuxdriver.com>
References: <20100402130828O.fujita.tomonori@lab.ntt.co.jp>
	<20100406210228.GD3017@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20100407093416X.fujita.tomonori@lab.ntt.co.jp>
Date: Wed, 07 Apr 2010 09:34:16 +0900
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 6 Apr 2010 17:02:28 -0400
"John W. Linville" <linville@tuxdriver.com> wrote:

> On Fri, Apr 02, 2010 at 01:10:38PM +0900, FUJITA Tomonori wrote:
> > The DMA API is preferred.
> > 
> > No functional change.
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> 
> Again, what tree is this against?  mwl8k fails to build after this patch.

Oops, sorry. It was against net-next. I've just got wireless-next and
found that it doesn't have the DMA state API yet, which was introduced
on 2.6.34-rc2. When do you plan to update your tree? I'll work on both
patches again later on.

Thanks,
