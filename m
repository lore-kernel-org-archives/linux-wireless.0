Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27309 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753977Ab0BJRrJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Feb 2010 12:47:09 -0500
Subject: Re: [PATCH] iwlwifi: use dma_alloc_coherent
From: reinette chatre <reinette.chatre@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"lkml@Think-Future.de" <lkml@Think-Future.de>,
	Linux Kernel-Liste <linux-kernel@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20100210130744.GA3935@dhcp-lab-161.englab.brq.redhat.com>
References: <20100206170348.GB9411@localhost>
	 <20100208143118.e8e5a1ee.akpm@linux-foundation.org>
	 <20100209165247.GB2512@dhcp-lab-161.englab.brq.redhat.com>
	 <1265735092.2551.1835.camel@rchatre-DESK>
	 <20100210082137.GA2519@dhcp-lab-161.englab.brq.redhat.com>
	 <20100210130744.GA3935@dhcp-lab-161.englab.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Feb 2010 09:47:05 -0800
Message-ID: <1265824025.2551.1875.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On Wed, 2010-02-10 at 05:07 -0800, Stanislaw Gruszka wrote:
> Change pci_alloc_consistent() to dma_alloc_coherent() so we can use
> GFP_KERNEL flag.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---

This looks good - thank you very much. I am going to include it in our
testing for a bit and then I will send it upstream for you with our
other pending patches. 

Reinette


