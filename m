Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:27950 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbbCKUor (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2015 16:44:47 -0400
Message-ID: <5500A93C.7060309@broadcom.com> (sfid-20150311_214450_870852_E287C79E)
Date: Wed, 11 Mar 2015 21:44:44 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: German <gentgerman@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iw dev wlp1s0 scan hangs
References: <20150311161757.dac357e24509141a4c98e84b@gmail.com>	<5500A4B6.4050702@broadcom.com> <20150311163353.74922db84fc618b3b9039515@gmail.com>
In-Reply-To: <20150311163353.74922db84fc618b3b9039515@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/11/15 21:33, German wrote:
> On Wed, 11 Mar 2015 21:25:26 +0100
> Arend van Spriel<arend@broadcom.com>  wrote:
>
>> On 03/11/15 21:17, German wrote:
>>> Hi. When I try to run aformentioned command it hangs for about 20 secs and no output is returned. What's the problem might be? Thanks
>>
>> any more details you can share? What kernel version, what specific
>> device is wlp1s0, do you have any kernel logging.
>>

When I wrote down the questions I was wondering how specifc I should be.
> Kernel 3.18.7-gentoo.

ok

> wlp1s0 is my network card.

Sure. I meant what brand and model.

Can you run following commands:
$ lspci
$ lsusb

> As for kernel logging, I simply don't know if I have it. Thanks

Ok. Can you run following command after aborting the hanging iw scan 
command:

$ dmesg

Regards,
Arend

>> Regards,
>> Arend
>
>

