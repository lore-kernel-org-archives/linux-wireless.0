Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3958 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757877Ab2EJLBs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 07:01:48 -0400
Message-ID: <4FABA007.2080203@broadcom.com> (sfid-20120510_130151_871150_2B3DD4AF)
Date: Thu, 10 May 2012 13:01:27 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Brent Roman" <brent@mbari.org>
cc: linux-wireless@vger.kernel.org
Subject: Re: After Kernel 3.3, brcmsmac won't work on mid-2010 Mac Mini
References: <4FA9A8FE.5000102@mbari.org> <4FAA1BEF.10704@broadcom.com>
 <4FAB0E12.7020006@mbari.org>
In-Reply-To: <4FAB0E12.7020006@mbari.org>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/10/2012 02:38 AM, Brent Roman wrote:
> 
> Thanks for the quick response.
> 
> I've not blacklisted bcma for either 3.2 or 3.3 kernels.
> Yes, I built the kernels myself.  The mac mini runs a Debian Mint 11.
> The brcmsmac driver in 3.3 seems to have dependencies on bcma, It won't
> load without it.
> When I reverte to 3.2.16, I just unconfigured the bcma driver, so it
> never built.
> the kernel .config for 3.2 and 3.3 are attached.
> Let me know if you need me to reboot the box with the 3.3 kernel and
> post dmesg or other logs.
> 
> - brent
> 
> 

The kernel configurations you sent me look fine. I noticed you have
debugging enabled for bcma and brcmsmac so can you sent me a dmesg for
the 3.3 kernel. lspci should show bcma as the driver for the device.
Unfortunately, there is no lsbcma.

Gr. AvS

