Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41486 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756382AbYHaJua (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Aug 2008 05:50:30 -0400
Message-ID: <48BA6962.7000202@gmx.net> (sfid-20080831_115041_770050_5AB6A751)
Date: Sun, 31 Aug 2008 11:50:26 +0200
From: Eric <plukje@gmx.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: rt2500 probe responses with wep and fragmented bit set
References: <48BA50CF.9030601@gmx.net>	 (sfid-20080831_100555_737564_C99DA302) <1220175856.2378.0.camel@johannes.berg>
In-Reply-To: <1220175856.2378.0.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg schreef:
> On Sun, 2008-08-31 at 10:05 +0200, Eric wrote:
>
>   
>> When analyzing the actual responses (tcpdumping on the mon.wlan0 iface, 
>> using wireshark to disect), I discovered that the probe responses for a 
>> SSID broadcast
>> had the WEP bit and the Fragmentation bit set, consistently, for all 
>> probe responses.
>>     
>
> You were looking at the wrong bit, the radiotap bit, which has little to
> do with what gets actually sent.
>
> johannes
>   
*sigh*
back to square 1.

Thanks,


Eric
