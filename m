Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from void.printf.net ([89.145.121.20]:42030 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180Ab0JGSBN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 14:01:13 -0400
Date: Thu, 7 Oct 2010 19:01:07 +0100
From: Chris Ball <cjb@laptop.org>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: ext Ohad Ben-Cohen <ohad@wizery.com>, Chris Ball <cjb@laptop.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Nicolas Pitre <nico@fluxnic.net>
Subject: Re: [PATCH v2 00/11] SDIO Runtime PM Support
Message-ID: <20101007180107.GA15745@void.printf.net>
References: <1286020455-28946-1-git-send-email-ohad@wizery.com> <1286454736.27371.37.camel@chilepepper>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1286454736.27371.37.camel@chilepepper>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luciano, Ohad,

On Thu, Oct 07, 2010 at 03:32:16PM +0300, Luciano Coelho wrote:
> I have tested this on my beagle board with the wl1271 patches that Ohad
> provided and it seems to be working fine.  I've also created a small
> script to stress test the implementation a little bit and didn't see any
> problems.
> 
> Tested-by: Luciano Coelho <luciano.coelho@nokia.com>
> 
> This is quite an important fix in the wl1271 point-of-view.  Chris, do
> you think there is any chance that this could make it to 2.6.37?

Yes, can do -- the patchset looks good, and I've just pushed patches
1-9 (the MMC patches) to mmc-next.  Please go ahead and submit the
two wl1271 patches through wireless-testing whenever you're ready.

Thanks!

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
