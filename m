Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-1.cc.uic.edu ([128.248.155.182]:48709 "EHLO
	mail-1.cc.uic.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933145Ab0HEQus (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Aug 2010 12:50:48 -0400
Message-ID: <4C5AEBE2.5060907@uic.edu>
Date: Thu, 05 Aug 2010 11:50:42 -0500
From: ABM Musa <amusa2@uic.edu>
MIME-Version: 1.0
To: Daniel Haid <d.haid@gogi.tv>
CC: linux-wireless@vger.kernel.org
Subject: Re: Capturing packets with bad FCS in monitor mode
References: <201008051614.11546.d.haid@gogi.tv> <201008051819.55252.d.haid@gogi.tv> <4C5AE723.5070708@uic.edu> <201008051840.18914.d.haid@gogi.tv>
In-Reply-To: <201008051840.18914.d.haid@gogi.tv>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/05/2010 11:40 AM, Daniel Haid wrote:
>> I can get packets with crc error using this method and I get lot of
>> corrupted packets. I am using ath9k with openwrt for router station
>> pro+ubiquity sr-71A card and tplink 1043nd.
>>      
> I am using an ubiquity sr-71X card, and still not one corrupted packet.
>
> I think I need to artificially create and transmit a corrupted packet. How
> can I do that?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>    
I am not sure about how to create corrupted packets. Normally you should 
get lot of corrupted packets from surrounding transmission. In my case, 
monitor mode hangs sometime and I don't get any packets. Then if I 
delete the interface and create a new interface using the iw command I 
gave earlier, I get packets with crc error. You can also modify already 
created interface using

iw wlan0 set monitor flag fcsfail

Musa

