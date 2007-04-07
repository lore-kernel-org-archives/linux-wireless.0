Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:42798 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965280AbXDGEQO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Apr 2007 00:16:14 -0400
Message-ID: <46171B36.6090108@lwfinger.net>
Date: Fri, 06 Apr 2007 23:16:54 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: RFC: ieee80211: Spamming of log resulting from packets with ExtIV  not set
References: <4616DD7E.6010606@lwfinger.net> <20070407013848.GG16197@jm.kir.nu>
In-Reply-To: <20070407013848.GG16197@jm.kir.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni Malinen wrote:
> On Fri, Apr 06, 2007 at 06:53:34PM -0500, Larry Finger wrote:
>> Using bcm43xx-softmac, my log gets full of messages that look like:
>>
>> Apr  6 18:06:55 larrylap kernel: TKIP: ICV error detected: 
>> STA=00:14:bf:85:49:fa
> 
> Does the driver properly filter out FCS errors? If not, the proper fix
> is to fix the driver to do that. If yes, I'm quite surprised that you
> see these messages so frequently.

As far as I can tell, FCS errors are not filtered. I looked at other wireless drivers, and I can see 
where zd1211rw filters them, but I have not yet figured out what routine sets the error bits. Once I 
have that and filter them, I'll see if the log messages stop.

Thanks for the advice,

Larry

