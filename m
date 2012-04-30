Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:1031 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426Ab2D3J0x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Apr 2012 05:26:53 -0400
Date: Mon, 30 Apr 2012 11:26:50 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	davem@davemloft.net
Subject: Re: [PATCH] NFC: nci/data.c: quiet sparse noise about plain integer
 as NULL pointer
Message-ID: <20120430092650.GC31528@sortiz-mobl> (sfid-20120430_112717_224099_ECB1B210)
References: <201204261031.16737.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201204261031.16737.hartleys@visionengravers.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, Apr 26, 2012 at 10:31:16AM -0700, H Hartley Sweeten wrote:
> Pointers should be cleared with NULL, not 0.
> 
> Quiets a couple sparse warnings of the type:
> 
> warning: Using plain integer as NULL pointer
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
> Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: "David S. Miller" <davem@davemloft.net>
This one and the 4 other NFC patches applied to my nfc-next tree, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
