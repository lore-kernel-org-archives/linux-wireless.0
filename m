Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f188.google.com ([209.85.211.188]:37569 "EHLO
	mail-yw0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425Ab0CGENo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Mar 2010 23:13:44 -0500
Received: by ywh26 with SMTP id 26so2155386ywh.1
        for <linux-wireless@vger.kernel.org>; Sat, 06 Mar 2010 20:13:43 -0800 (PST)
Message-ID: <4B9327F4.1010109@lwfinger.net>
Date: Sat, 06 Mar 2010 22:13:40 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Malte Gell <malte.gell@gmx.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: iwconfig link quality only up to 70%
References: <201003070455.55312.malte.gell@gmx.de>
In-Reply-To: <201003070455.55312.malte.gell@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/06/2010 09:55 PM, Malte Gell wrote:
> Hello,
> 
> When i check the link quality iwconfig says "Link Quality=63/70".
> 
> I wonder, why does it stop at 70%? Why doesn't it say "63/100"?
> 
> I use Linux kernel 2.6.32 on openSUSE 11.1 with a Fritz! WLAN N stick. I know, 
> not a big issue, I am just curious.

It does not stop at 70%. In fact 63/70 == 90%. As all these signal and quality
numbers are purely arbitrary, they can be normalized in any way you want. In a
number of the Realtek vendor drivers, there is a comment "For Netgear case, they
want good-looking singal strength".

Larry
