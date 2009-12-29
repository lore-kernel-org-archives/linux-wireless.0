Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:44138 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbZL2CAt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Dec 2009 21:00:49 -0500
Date: Mon, 28 Dec 2009 21:00:48 -0500
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: Huaxu Wan <huaxu.wan@linux.intel.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Compat-wireless-2.6: Updated to fix bluetooth patch
	error
Message-ID: <20091229020048.GF30201@bombadil.infradead.org>
References: <20091225092225.GA11049@owl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20091225092225.GA11049@owl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 25, 2009 at 05:22:25PM +0800, Huaxu Wan wrote:
> 
> Compat-wireless-2.6: Updated to fix bluetooth patch error
> 
> Keep the patch in step with the linux-next tree after the following
> patch merged.
> 
>     commit 971beb83aeb2a309175682cf5683d64fd4591841
>     Author: Roel Kluin <roel.kluin@gmail.com>
>     Date:   Mon Dec 7 14:23:21 2009 +0100
> 
>         Bluetooth: Fix PTR_ERR return of wrong pointer in hidp_setup_hid()
> 
>         Return the PTR_ERR of the correct pointer.
>  
> Signed-off-by: Huaxu Wan <huaxu.wan@linux.intel.com>

Great thanks!

  Luis
