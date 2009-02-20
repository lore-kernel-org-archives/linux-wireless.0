Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:59891 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805AbZBTTMA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 14:12:00 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John W Linville <linville@tuxdriver.com>
Subject: Re: [PATCH 0/6] b43: Use spatch to convert register accesses
Date: Fri, 20 Feb 2009 20:10:23 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <200902201854.22114.mb@bu3sch.de>
In-Reply-To: <200902201854.22114.mb@bu3sch.de>
MIME-Version: 1.0
Message-Id: <200902202010.23916.mb@bu3sch.de> (sfid-20090220_201206_852130_4D297C89)
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 20 February 2009 19:19:15 Michael Buesch wrote:
> Some time ago I rejected a bunch of patches that converted the
> PHY/radio register accesses to the new API. That was due to the patches
> being created manually. This introduces a huge potential to add new bugs.
> 
> However, this is an excellent task for coccinelle/spatch.
> So here's a series of patches, to convert the API usage, that were generated
> with spatch. This should keep the chances of breaking something as low as possible.
> 
> This reduces the .ko size by about 6 kiB.
> 
> The used semantic patches will be included in the patch headers.
> 
> John, please queue these patches for the next feature release.
> 

Hm, the patches didn't get through linux-wireless. Possibly due to their size.
You can find them here:

https://lists.berlios.de/pipermail/bcm43xx-dev/2009-February/008696.html
https://lists.berlios.de/pipermail/bcm43xx-dev/2009-February/008695.html
https://lists.berlios.de/pipermail/bcm43xx-dev/2009-February/008697.html
https://lists.berlios.de/pipermail/bcm43xx-dev/2009-February/008698.html
https://lists.berlios.de/pipermail/bcm43xx-dev/2009-February/008700.html
https://lists.berlios.de/pipermail/bcm43xx-dev/2009-February/008699.html

-- 
Greetings, Michael.
