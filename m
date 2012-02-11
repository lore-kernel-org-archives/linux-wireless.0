Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout4.freenet.de ([195.4.92.94]:49425 "EHLO mout4.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754674Ab2BKO4u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Feb 2012 09:56:50 -0500
Received: from [195.4.92.140] (helo=mjail0.freenet.de)
	by mout4.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #1)
	id 1RwBe1-00023Y-Cn
	for linux-wireless@vger.kernel.org; Sat, 11 Feb 2012 13:01:34 +0100
Received: from localhost ([::1]:45394 helo=mjail0.freenet.de)
	by mjail0.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1RwBe0-0006l0-U0
	for linux-wireless@vger.kernel.org; Sat, 11 Feb 2012 13:01:33 +0100
Received: from [195.4.92.17] (port=57893 helo=7.mx.freenet.de)
	by mjail0.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1RwBbn-0002bG-02
	for linux-wireless@vger.kernel.org; Sat, 11 Feb 2012 12:59:15 +0100
Received: from [2002:4fde:13d9:2:5054:ff:feb8:40bd] (port=38602 helo=mail.maya.org)
	by 7.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1RwBbm-0004JQ-J1
	for linux-wireless@vger.kernel.org; Sat, 11 Feb 2012 12:59:14 +0100
Message-ID: <4F365804.2050705@01019freenet.de> (sfid-20120211_155653_981422_39DBB39C)
Date: Sat, 11 Feb 2012 12:59:00 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Alfonso Fiore <alfonso.fiore@gmail.com>
CC: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
Subject: Re: Setting up an AP @ 5 GHz 802.11a - hostapd refuses [Could not
 select hw_mode and channel. (-1)]
References: <CAO=xpBHy9p4yzhxaWTfG+jjw7f_OzbACmxxPnDL8AmLBS-JdwQ@mail.gmail.com> <CAO=xpBGT7ovdSOV77AV6wpUcTDFYr0t8GEab474mVmZm0-BhVA@mail.gmail.com> <20120207171538.3336af0c@mj> <CAO=xpBGRs_kYtt_w6aG2dFjO4Pgd9MrjPwn7YfuLe7bw3mGiPg@mail.gmail.com> <4F34BF3C.9030809@01019freenet.de> <CAO=xpBFKOAdTEi1DMfJxWCCv9oEtJpuLjuN4uNPNRgN1iWG85Q@mail.gmail.com> <4F358902.3040009@01019freenet.de> <CAO=xpBEvmd7=0EK68+MUQMgFVXL47tQYGc-2X8Rt0NfJdszUkw@mail.gmail.com>
In-Reply-To: <CAO=xpBEvmd7=0EK68+MUQMgFVXL47tQYGc-2X8Rt0NfJdszUkw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alfonso Fiore schrieb:
> On Fri, Feb 10, 2012 at 10:15 PM, Andreas Hartmann
> <andihartmann@01019freenet.de> wrote:
>>
>> Alfonso Fiore schrieb:
>>> On Fri, Feb 10, 2012 at 7:54 AM, Andreas Hartmann
>> [...]
>>> # find / | grep ath5k.ko
>>> /lib/modules/3.0.0-voyage/kernel/drivers/net/wireless/ath/ath5k/ath5k.ko
>>> /lib/modules/3.0.0/updates/drivers/net/wireless/ath/ath5k/ath5k.ko
>>> /root/compat-wireless-3.3-rc1-2/drivers/net/wireless/ath/ath5k/ath5k.ko
>>> /root/compat-wireless-3.3-rc1-2/drivers/net/wireless/ath/ath5k/.ath5k.ko.cmd
>>>
>>> I tried depmod -a and also a simple reboot (which I always do after
>>> make install) but the "updates" module is never loaded.
>>>
>>> Any idea?
>>
>> Sorry for being late. I worked on my machine and wasn't able to read any
>> mails.
>>
>>
>> I do have a config file for depmod in /etc/depmod.d called
>> 00-system.conf, which has the following entries:
> 
> Hi Andreas,
> 
> I do not have a /etc/depmod.d folder. I imagine it is something about
> my embedded distribution (voyage 0.8.0).
> 
> I asked for help there. I will post back is they have any suggestion.

This is a good idea especially as I don't know anything of this
distribution and don't have it here for testing.

I hope you get some help there. Maybe man depmod or man depmod.conf
knows something more? E.g., I don't have a /etc/depmod.conf file. Maybe
you have one?


Good luck,
regards,
Andreas
