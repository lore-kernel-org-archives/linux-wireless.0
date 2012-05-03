Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:44064 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751236Ab2ECMwh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 08:52:37 -0400
Received: by lboj14 with SMTP id j14so894750lbo.21
        for <linux-wireless@vger.kernel.org>; Thu, 03 May 2012 05:52:34 -0700 (PDT)
Message-ID: <1336049553.12189.26.camel@cumari.coelho.fi> (sfid-20120503_145241_482700_0114E371)
Subject: Re: [PATCH] wlcore: use GFP_KERNEL together with GFP_DMA
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: dan.carpenter@oracle.com
Date: Thu, 03 May 2012 15:52:33 +0300
In-Reply-To: <1336030475-28943-1-git-send-email-coelho@ti.com>
References: <1336030475-28943-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-05-03 at 10:34 +0300, Luciano Coelho wrote:
> GFP_DMA should not be used by itself, it still needs GFP_KERNEL or
> such.  Fix two occurrences of allocations with GFP_DMA only.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---

Applied.

