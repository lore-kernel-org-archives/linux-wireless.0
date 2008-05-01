Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54525 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753156AbYEAQ3O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 May 2008 12:29:14 -0400
Date: Thu, 1 May 2008 17:20:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Michael Buesch <mb@bu3sch.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
	John Linville <linville@tuxdriver.com>,
	Andi Kleen <andi@firstfloor.org>,
	David Miller <davem@davemloft.net>,
	Ingo Molnar <mingo@elte.hu>, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org,
	"linux-kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] Add dma_set_mask_weak() API
Message-ID: <20080501172045.35686f43@core> (sfid-20080501_182901_585419_09A9B299)
In-Reply-To: <200805011640.17281.mb@bu3sch.de>
References: <200805011638.15910.mb@bu3sch.de>
	<200805011640.17281.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 1 May 2008 16:40:16 +0200
Michael Buesch <mb@bu3sch.de> wrote:

> This adds a new DMA subsystem API call for "weak" setting
> of the DMA mask

weak is an odd term - and we use weak for things like weak symbols so it
might be confusing. dma_request_mask() ?

Alan
