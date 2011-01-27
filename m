Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63997 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab1A0OjU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 09:39:20 -0500
Received: by vws16 with SMTP id 16so737828vws.19
        for <linux-wireless@vger.kernel.org>; Thu, 27 Jan 2011 06:39:19 -0800 (PST)
Message-ID: <4D4183BD.3060609@lwfinger.net>
Date: Thu, 27 Jan 2011 08:39:57 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: raghunathan.kailasanathan@wipro.com
CC: linux-wireless@vger.kernel.org
Subject: Re: unable to put RTL8192SU in master mode
References: <6D6CA94E9F944C45ABD35E9F7E1CAE619BBF56D579@BLR-SJP-MB02.wipro.com>
In-Reply-To: <6D6CA94E9F944C45ABD35E9F7E1CAE619BBF56D579@BLR-SJP-MB02.wipro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/27/2011 07:31 AM, raghunathan.kailasanathan@wipro.com wrote:
> Hi folks,
> I have a USB dongle with realtek 8192SU wireless chipset and am using the 8712u linux driver.

The driver from the Realtek web site is named 8712u, and the one in the kernel
staging tree (2.6.37 and later) is called r8712u. Which one are you using? They
are not the same.

> Since this driver is not mac80211 compliant I am using iwconfig to change the mode to "master". Though this
> command successfully changes the mode I am unable to connect to this AP from another station, even using
> unsecured method. It does not even show up in the station scan list.  Are there some other params I need to 
> set using iwconfig ?
> 
> Or is the 8712u driver not supporting master mode "sufficiently" enough ?...in which case is some latest
> driver available for this thing?

Master mode with r8712u has not been tested. The driver I started with has a
configuration parameter that enables "AP mode". I kept that in, but I do not
know if it works.

Larry

