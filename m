Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f227.google.com ([209.85.217.227]:48455 "EHLO
	mail-gx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab0BQRCK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 12:02:10 -0500
Received: by gxk27 with SMTP id 27so1484081gxk.1
        for <linux-wireless@vger.kernel.org>; Wed, 17 Feb 2010 09:02:09 -0800 (PST)
Message-ID: <4B7C2107.10903@lwfinger.net>
Date: Wed, 17 Feb 2010 11:01:59 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] p54: Add Belkin / Accton 083a:f503
References: <20100217110855.1b626214@tele>
In-Reply-To: <20100217110855.1b626214@tele>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/17/2010 04:08 AM, Jean-Francois Moine wrote:
> Hello Michael,
> 
> I have 2 wifi dongles named Belkin FD7050E ver 1010ec.
> 
> They used to work with ndiswrapper, either with ehci_hcd or ohci_hcd
> (not the same on 2 different machines! - note that the ms-win driver
> often crashed windows XP when I still used it).
> 
> I just added the vend:prod in the p54usb driver which comes in
> linux-2.6.32-3 and it works fine on a 686 with ehci_hcd (but not with
> ohci_hcd).
> 
> May you apply the attached patch to the kernel?

Thanks for the info. As you have probably already seen, I submitted the patch a
few minutes ago.

Larry
