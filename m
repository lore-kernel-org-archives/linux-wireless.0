Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:48776 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab3LMIty (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Dec 2013 03:49:54 -0500
Message-ID: <52AAC9B8.8060008@broadcom.com> (sfid-20131213_094957_007882_C5993352)
Date: Fri, 13 Dec 2013 09:47:52 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Naughtboy <skylvlinux@gmail.com>, <b43-dev@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: where can download bcm43236 linux driver code!!
References: <CAKH5=LsbEAVX4_=EEukJnGkKbiG--RzywvK+wOGhmh3zz6pkxA@mail.gmail.com> <52AAA948.1000509@lwfinger.net>
In-Reply-To: <52AAA948.1000509@lwfinger.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/13/2013 07:29 AM, Larry Finger wrote:
> On 12/12/2013 08:48 PM, Naughtboy wrote:
>> hell big guys
>> now i have a usbdognle  bcm4323
>> but i did'nt have it driver code (linux)
>> if you kown it , please let'us kown it
>> thanks adanvce!!
>
> As far as I know, there are no Linux drivers for any Broadcom USB adapters.

Not sure how the subject got changed from bcm4323 to bcm43236. The 
brcmfmac driver has support for the bcm43236 for almost two years, 
but... only for particular chip revision. Earlier revisions of that chip 
do not have enough memory for fullmac support (see [1] for details). If 
it is really about a bcm4323 the answer is it does not support fullmac 
either.

Regards,
Arend

[1] wireless.kernel.org/en/users/Drivers/brcm80211

