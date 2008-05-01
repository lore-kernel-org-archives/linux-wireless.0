Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37252
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757440AbYEAVju (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 May 2008 17:39:50 -0400
Date: Thu, 01 May 2008 14:39:49 -0700 (PDT)
Message-Id: <20080501.143949.20091241.davem@davemloft.net> (sfid-20080501_233933_407093_A6CB3FDE)
To: alan@lxorguk.ukuu.org.uk
Cc: hch@infradead.org, mb@bu3sch.de, jbarnes@virtuousgeek.org,
	linville@tuxdriver.com, andi@firstfloor.org, mingo@elte.hu,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Add API for weak DMA masks
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080501172913.08975881@core>
References: <200805011638.15910.mb@bu3sch.de>
	<20080501153618.GA470@infradead.org>
	<20080501172913.08975881@core>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Thu, 1 May 2008 17:29:13 +0100

> We have tons of drivers that go
> 
> 	try and set 64bit 
> 	oh failed
> 	try and set 32 bit
> 	oh worked
> 
> When what most actually want is "set it no more than this wide" - a
> request or even a "pci_set_best_mask()" type idea.
> 
> Lots less code duplication.

Agreed, it's a templated construct and it belongs in one
spot.
