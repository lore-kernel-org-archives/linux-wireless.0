Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:50734 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752818Ab2ECMzA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 08:55:00 -0400
Received: by lagw12 with SMTP id w12so249910lag.24
        for <linux-wireless@vger.kernel.org>; Thu, 03 May 2012 05:54:57 -0700 (PDT)
Message-ID: <1336049695.12189.29.camel@cumari.coelho.fi> (sfid-20120503_145514_219707_15B5AF56)
Subject: Re: [patch] wlcore: fixup an allocation
From: Luciano Coelho <coelho@ti.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Eliad Peller <eliad@wizery.com>,
	Arik Nemtsov <arik@wizery.com>,
	Shahar Levi <shahar_levi@ti.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Thu, 03 May 2012 15:54:55 +0300
In-Reply-To: <20120417062847.GA26756@elgon.mountain>
References: <20120417062847.GA26756@elgon.mountain>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-04-17 at 09:28 +0300, Dan Carpenter wrote:
> GFP_DMA isn't supposed to be used by itself.  This allocation is allowed
> to sleep so it should be ORing it with GFP_KERNEL.
> Also we should check for allocations errors.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> I don't have the hardware to test this.  Sorry.

Applied, thanks! I ran some very basic tests on it.

