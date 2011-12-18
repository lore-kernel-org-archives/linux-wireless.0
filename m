Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:34321 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876Ab1LRUjG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Dec 2011 15:39:06 -0500
Date: Sun, 18 Dec 2011 21:43:35 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch 2/2] NFC: use kfree_skb() for sk_buffs
Message-ID: <20111218204335.GR11800@sortiz-mobl> (sfid-20111218_213912_238886_92AAE19E)
References: <20111216202600.GB18570@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20111216202600.GB18570@elgon.mountain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

On Fri, Dec 16, 2011 at 11:26:00PM +0300, Dan Carpenter wrote:
> This is a struct sk_buff pointer and it should be freed with kfree_skb()
> instead of kfree().
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
