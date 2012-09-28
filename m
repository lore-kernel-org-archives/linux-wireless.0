Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:59660 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754165Ab2I1ItR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2012 04:49:17 -0400
Received: by bkcjk13 with SMTP id jk13so3023421bkc.19
        for <linux-wireless@vger.kernel.org>; Fri, 28 Sep 2012 01:49:15 -0700 (PDT)
Message-ID: <1348822129.15949.3.camel@cumari.coelho.fi> (sfid-20120928_104923_057855_CFA06B05)
Subject: Re: [PATCH] wl12xx: use module_platform_driver
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Date: Fri, 28 Sep 2012 11:48:49 +0300
In-Reply-To: <1348736780-3165-1-git-send-email-luca@coelho.fi>
References: <1348736780-3165-1-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-09-27 at 12:06 +0300, Luciano Coelho wrote:
> Use a module_platform_driver declaration instead of replicating the
> init and exit functions in the driver.
> 
> Based on the patch for wl18xx by Devendra Naga.
> 
> Signed-off-by: Luciano Coelho <luca@coelho.fi>
> ---

Applied.

--
Luca.

