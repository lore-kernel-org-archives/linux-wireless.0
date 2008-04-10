Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:53469 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753439AbYDJDkG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2008 23:40:06 -0400
Message-ID: <47FD8C0E.3060807@lwfinger.net> (sfid-20080410_044035_629754_90E91589)
Date: Wed, 09 Apr 2008 22:39:58 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH] Add Realtek 8187B support
References: <200804081931.07638.herton@mandriva.com.br>
In-Reply-To: <200804081931.07638.herton@mandriva.com.br>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Herton Ronaldo Krzesinski wrote:
> Hi, this patch (made against wireless-testing repository) adds support for
> 8187B to the rtl8187 module. 

I want to give a "heads up" to the users of this driver. This 
afternoon, I was using flood pings on my RTL8187B at different 
transmission rates to determine how well the device worked. In the 
middle of the 3rd test, the device failed, and no longer has the 
ability to transmit. I have no way of knowing if that was just the 
time that it failed, or if the driver is overpowering the transmitter. 
In any case, you should watch for problems.

Larry
