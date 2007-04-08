Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:51098 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751224AbXDHOIS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Apr 2007 10:08:18 -0400
Message-ID: <4618F787.9080903@lwfinger.net>
Date: Sun, 08 Apr 2007 09:09:11 -0500
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

According to Johannes Berg and Michael Buesch, the bcm43xx firmware filters the frames with FCS 
errors before they even get to the driver. I'm still looking to see if I can find a way to filter 
the offending packets further to keep them from getting to ieee80211.

Thanks,

Larry

