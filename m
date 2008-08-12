Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:35012 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbYHLGEy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Aug 2008 02:04:54 -0400
Message-ID: <48A127C2.7060300@au-79.de> (sfid-20080812_080458_100957_03783A14)
Date: Tue, 12 Aug 2008 08:03:46 +0200
From: Robert Goldner <robert@au-79.de>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>
CC: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Problems with Belkin F5D7010 PCMCIA 1799:701f while trying WPA
 connection
References: <489EAA04.8070203@au-79.de> <489EF765.8050000@lwfinger.net> <489F501C.5070408@au-79.de> <489F5508.2020808@lwfinger.net>
In-Reply-To: <489F5508.2020808@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger schrieb:
> Robert Goldner wrote:
>>
>> The ifconfig output seems good (like other working wlan cards), and 
>> the interface is up. But iwlist wlan0 scan does not find any 
>> wlan-network. Very strange, because I made this test very close to the 
>> access-point (about 30 cm distance). With other wlan-cards I get 
>> signal levels of ~80% of maximum. So maybe the receiving part is 
>> broken. I can not test the hardware with the windows-driver, because I 
>> don't have a windows-installation.
> 
> Just for the record, you should run iwlist as root. That is the only
> way you will get an active scan. In addition, it may take several
> tries; however, wpa_supplicant did all that before without finding any
> results. A broken card is a strong possibility. Do any of your
> colleagues have Windows?
> 
> Larry
> 
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

My fried has an old laptop with windowsXP, and at his laptop the card 
detects my network (after installation of the driver). So the card 
itself seems to be ok. A WPA connection is not possible, because the 
windows-installation is very old (before SP1), so there is no 
WPA-support, but a WEP-connection was possible.

iwlist was run as root. I made an other try, boot with acpi=off, but the 
same result.

A try with ndiswrapper is not so easy, because my actual kernel uses 4k 
stacks, and this is not really compatible with ndiswrapper.

When I searched for the windows-driver, I got the information from 
belkin, that there are 7 different versions of the card possible. My 
card has a version 7000de, which means version 7. See
http://www.belkin.com/de/support/article/?lid=en&pid=F5D7010de&aid=7422&scid=342
(only in german, but saying that the first number of the version string 
means the needed software version).

Any ideas?

Robert
