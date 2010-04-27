Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 27.mail-out.ovh.net ([91.121.30.210]:50468 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753292Ab0D0TXL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Apr 2010 15:23:11 -0400
Message-ID: <4BD7399B.9040104@free.fr>
Date: Tue, 27 Apr 2010 21:23:07 +0200
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: Joerg Pommnitz <pommnitz@yahoo.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k: remove usage of deprecated noise value
References: <1272312561-22648-1-git-send-email-linville@tuxdriver.com> <4BD682AF.6030206@free.fr> <loom.20100427T125258-288@post.gmane.org>
In-Reply-To: <loom.20100427T125258-288@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joerg Pommnitz a écrit :
> Benoit PAPILLAULT <benoit.papillault@...> writes:
>   
>> Before removing noise reporting and all related code, wouln't it be 
>> better to have a replacement API? 
>>     
>
> I thought this is what NL80211_CMD_GET_SURVEY is supposed to do...
> See
> http://osdir.com/ml/linux-wireless/2009-11/msg00977.html
>
>   
Thanks Joerg! I tried : iw dev wlan0 survey dump and nothing show up.
What drivers are supposed to have this feature implemented?

Anyway, I really like to have it implemented for ath9k before removing 
the deprecated noise value. If it's not currently implemented, I'll try 
my best to send a patch in the next couple of days. I'll try then to 
implement it for ath5k (already done?), ar9170, zd1211rw (if possible), 
rt2800usb/pci.

BTW, on rt2800usb/pci, it seems the noise is reported on a per packet 
basis by HW. Kinda strange isn't it? :-]

Regards,
Benoit

