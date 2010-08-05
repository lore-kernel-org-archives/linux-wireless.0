Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-4.cc.uic.edu ([128.248.155.184]:36885 "EHLO
	mail-4.cc.uic.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933683Ab0HEQag (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Aug 2010 12:30:36 -0400
Message-ID: <4C5AE723.5070708@uic.edu>
Date: Thu, 05 Aug 2010 11:30:27 -0500
From: ABM Musa <amusa2@uic.edu>
MIME-Version: 1.0
To: Daniel Haid <d.haid@gogi.tv>
CC: linux-wireless@vger.kernel.org
Subject: Re: Capturing packets with bad FCS in monitor mode
References: <201008051614.11546.d.haid@gogi.tv> <475A8455ABBB4AD79E2B0AD03B1F69B9@personal> <201008051819.55252.d.haid@gogi.tv>
In-Reply-To: <201008051819.55252.d.haid@gogi.tv>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/05/2010 11:19 AM, Daniel Haid wrote:
>> Packets with crc error can be captured using corresponding flag of iw.
>>
>> iw phy phy0 interface add wlan0 type monitor flags fcsfail
>>      
> Is this supported on ath9k? I do not see any difference so far
> with the packet capturing.
> I also do not find the FIF_FCSFAIL flag be used anywhere in
> the ath9k code.
>
> Will I get lots of corrupted packets if this is enabled properly or only
> casually?
>
>    

I can get packets with crc error using this method and I get lot of 
corrupted packets. I am using ath9k with openwrt for router station 
pro+ubiquity sr-71A card and tplink 1043nd.

Musa
