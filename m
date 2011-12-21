Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from numidia.opendz.org ([98.142.220.152]:41826 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab1LUTp6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 14:45:58 -0500
Date: Wed, 21 Dec 2011 20:48:52 +0100
From: Djalal Harouni <tixxdz@opendz.org>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] drivers/iwlwifi: use dma_zalloc_coherent() for DMA
 allocation
Message-ID: <20111221194852.GA19795@dztty> (sfid-20111221_204603_961129_59FC35C0)
References: <20111221002147.GA4996@dztty>
 <1324486330.13074.322.camel@wwguy-huron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1324486330.13074.322.camel@wwguy-huron>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 21, 2011 at 08:52:10AM -0800, Guy, Wey-Yi wrote:
> Hi Djalal,
> 
> 
> On Tue, 2011-12-20 at 16:21 -0800, Djalal Harouni wrote:
> > Replace dma_alloc_coherent()+memset() with the new dma_zalloc_coherent()
> > 
> > Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
> > ---
> 
> iwl-trans-pcie.c is one of the source files in iwlwifi driver hold
> dual-license (GPL + BSD), are you ok to release your code for the BSD
> license and relinquish the copyright?
Yes, It's ok.

> btw, we are in the process of rewrite and re-architect major portion of
> iwlwifi driver, and we also plan to make most of the code dual-license
> (GPL + BSD).
>
> Thanks you in advance
> 
> Wey
Thanks Wey.

-- 
tixxdz
http://opendz.org
