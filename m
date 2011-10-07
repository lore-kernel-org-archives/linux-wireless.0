Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:58112 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758214Ab1JGGVa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 02:21:30 -0400
Received: by bkbzt12 with SMTP id zt12so5588515bkb.40
        for <linux-wireless@vger.kernel.org>; Thu, 06 Oct 2011 23:21:28 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: remove sdio_test module
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
In-Reply-To: <1317933089-16128-1-git-send-email-coelho@ti.com>
References: <1317933053.3549.66.camel@cumari>
	 <1317933089-16128-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Oct 2011 09:21:20 +0300
Message-ID: <1317968480.3549.76.camel@cumari> (sfid-20111007_082134_337086_CBFA0790)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-10-06 at 23:31 +0300, Luciano Coelho wrote: 
> This module has been causing more trouble than being useful.  It only
> tests the SDIO speed by connecting to the wl12xx chip and does some
> throughput calculations.  It is an ugly quick hack and, if we really
> want to have it as part of wl12xx we need to clean it up and implement
> it properly.
> 
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---

Okay, my mood today, influenced by Kalle's opinion, was to remove this
module from the kernel.  So I applied this patch and added a URL that
points to the wikipage were information (and a tarball) can be found in
case someone wants to use it.

Applied.

-- 
Cheers,
Luca.

