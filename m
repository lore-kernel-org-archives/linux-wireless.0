Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:18789 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933213AbZGPUUn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 16:20:43 -0400
Subject: Re: PCI express card that does AP mode? (abit wlp-01?)
From: Pavel Roskin <proski@gnu.org>
To: Jon Fairbairn <jon.fairbairn@cl.cam.ac.uk>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <wf1vogmujw.fsf@calligramme.charmers>
References: <wfljmpm4xl.fsf@calligramme.charmers>
	 <1247762215.4235.21.camel@mj>   <wf1vogmujw.fsf@calligramme.charmers>
Content-Type: text/plain
Date: Thu, 16 Jul 2009 16:20:41 -0400
Message-Id: <1247775641.6841.16.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-07-16 at 18:01 +0100, Jon Fairbairn wrote:

> Ah, thanks for that. Three questions arise:
> 
> Are the pci ids quoted above recognised as needing ath5k?

Yes, 168c:001c is served by ath5k.

> Is the WLP-01 really ath5k/really have those ids?

The Abit site had only one driver for WLP-01. There are references that
some WLP-01 devices use Atheros chipset.  Thus we conclude that all
WLP-01 use Atheros chipset, or there would be more that one driver.

The Atheros PCI ID is 168c.  Search on Google for "WLP-01 168c" without
quotes finds 001c everywhere.  So it should work with ath5k.

I cannot guarantee anything, but I think chances are very high.

> The distro I'm using (fedora 11) has 2.6.29 -- will the relevant modules
> build for that, or would I have to build a whole 2.6.31?

You can build compat-wireless, which includes the latest ath5k driver
backported from the wireless-testing kernel.  Alternatively, you can
build madwifi (be sure to use the trunk snapshot).

-- 
Regards,
Pavel Roskin
