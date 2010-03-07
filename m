Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:46015 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753535Ab0CGEX7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Mar 2010 23:23:59 -0500
From: Malte Gell <malte.gell@gmx.de>
To: linux-wireless@vger.kernel.org
Subject: Re: iwconfig link quality only up to 70%
Date: Sun, 7 Mar 2010 05:23:55 +0100
References: <201003070455.55312.malte.gell@gmx.de> <4B9327F4.1010109@lwfinger.net>
In-Reply-To: <4B9327F4.1010109@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201003070523.55526.malte.gell@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Larry Finger <Larry.Finger@lwfinger.net> wrote

> On 03/06/2010 09:55 PM, Malte Gell wrote:
> > Hello,
> >
> > When i check the link quality iwconfig says "Link Quality=63/70".
> >
> > I wonder, why does it stop at 70%? Why doesn't it say "63/100"?
> >
> > I use Linux kernel 2.6.32 on openSUSE 11.1 with a Fritz! WLAN N stick. I
> > know, not a big issue, I am just curious.
 
> It does not stop at 70%. In fact 63/70 == 90%. As all these signal and
>  quality numbers are purely arbitrary, they can be normalized in any way
>  you want. 

Ok, I understand.

>  In a number of the Realtek vendor drivers, there is a comment
>  "For Netgear case, they want good-looking singal strength".

:-)
