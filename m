Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout1-sn1.fre.skanova.net ([81.228.11.98]:49176 "EHLO
	pne-smtpout1-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755424AbYG3T4D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 15:56:03 -0400
Message-ID: <4890B6F1.40607@gmail.com> (sfid-20080730_215624_370480_99B73708)
Date: Wed, 30 Jul 2008 20:46:09 +0200
From: johan henriksson <jhn98032@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: RTL8187: RTL8187B with id 0bda:8198
References: <489037EC.4020306@gmail.com> <48905BD8.3030100@lwfinger.net>
In-Reply-To: <48905BD8.3030100@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks Larry for the help!
I have tried the patches and now it works better but the network still stops
working after a while (and DNS lookup doesn't work at all?).

Larry Finger wrote:
> To quote the RealTek engineers, "The rtl8187B card with VID 8198 is only 
> for Toshiba. But It is regrettable that we can't provide open source of 
> that, because we have some agreements with Toshiba." All that they will 
> say is that the part is different.

The question is how different the 8197 and 8198 are. They can't be totally incompatible
  since the driver almost works?

> Have you run this card with ndiswrapper? If so, you should be able to 
> use usbmon to dump the traffic and find what is being sent to the chip 
> by the Windows driver that the native driver does not. Perhaps a timer 
> reset will be found that way.

Unfortunately I haven't got ndiswrapper to work with the card. I have tried the winxp driver
  from toshiba, winxp driver from realtek and the win98 driver (forced) from realtek without success.
There are no error messages at all so I really do not know what the problem is.


/Johan
