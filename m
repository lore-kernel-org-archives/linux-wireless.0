Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3248 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840Ab2BEMk3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Feb 2012 07:40:29 -0500
Message-ID: <4F2E7891.3020507@broadcom.com> (sfid-20120205_134033_028033_983E8A3B)
Date: Sun, 5 Feb 2012 13:39:45 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Frank A. Kingswood" <frank@kingswood-consulting.co.uk>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Kernel panic with brcm4313 (kernel 3.2.2)
References: <jgjoab$l54$1@dough.gmane.org>
In-Reply-To: <jgjoab$l54$1@dough.gmane.org>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/04/2012 06:02 PM, Frank A. Kingswood wrote:
> Hi,
> 
> On a new (Samsung 305U1A) laptop with BRCM4313 wireless I have not been 
> able to use the wireless at all, although occasionally a flicker of life
> can be seen in it.
> 
> "iwconfig scan" usually fails to report more than one access point. 
> Disabling the local AP makes it show up a different one, suggesting it
> is actually able to see it but somewhere fails to pass the data along.
> 
> Fiddling with NetworkManager produces this kernel panic:

Also a full dmesg log would be helpful.

Gr. AvS


