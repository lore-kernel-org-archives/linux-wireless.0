Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:25007 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755536Ab0FCQ1W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jun 2010 12:27:22 -0400
Subject: Re: [PATCH] iwlwifi: use the DMA state API instead of the pci
 equivalents
From: reinette chatre <reinette.chatre@intel.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: "Zhu, Yi" <yi.zhu@intel.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
In-Reply-To: <20100603141853Z.fujita.tomonori@lab.ntt.co.jp>
References: <20100603141853Z.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Jun 2010 09:27:21 -0700
Message-ID: <1275582441.2091.31678.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-06-02 at 22:19 -0700, FUJITA Tomonori wrote:
> This can be cleanly applied to wireless-2.6 and iwlwifi git trees.
> 
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] iwlwifi: use the DMA state API instead of the pci equivalents
> 
> This replace the PCI DMA state API (include/linux/pci-dma.h) with the
> DMA equivalents since the PCI DMA state API will be obsolete.

Does that mean we need to modify out other PCI DMA calls (eg.
pci_unmap_single etc.) also?

> 
> No functional change.
> 
> For further information about the background:
> 
> http://marc.info/?l=linux-netdev&m=127037540020276&w=2
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Thank you

Acked-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette


