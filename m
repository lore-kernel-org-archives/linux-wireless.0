Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41896 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175Ab2DKIyj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 04:54:39 -0400
Message-ID: <4F8546C7.40703@qca.qualcomm.com> (sfid-20120411_105451_850696_5D0D7B74)
Date: Wed, 11 Apr 2012 11:54:31 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Anthony Ginger <mapfly@gmail.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: ath6kl hostapd
References: <CAK0tYSKLhALwUca2LPiRLfXTK-Qt3Oh3Lvk=V272AXdb=aAP7w@mail.gmail.com> <4F4B25F5.4090204@qca.qualcomm.com>
In-Reply-To: <4F4B25F5.4090204@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/27/2012 08:43 AM, Kalle Valo wrote:
> On 02/16/2012 01:30 PM, Anthony Ginger wrote:
> 
>> Can ath6kl support AP mode? If yes, how to config it? I tried a
>> simplest config, but can't find the AP.
> 
> I have used AP mode only with wpasupplicant, I haven't tried with
> hostapd yet. I would guess that ath6kl works with hostapd as well but of
> course there can be some issues.

Sorry for taking so long to answer but I finally tested this myself.

With latest firmware 3.2.0.144 (which I submitted to linux-firmware.git
yesterday) and latest hostapd from git I can create a WPA-PSK network
using hostapd and my Nokia N900 succesfully connected to the network and
I was able to ping N900.

If this is not working for you I recommend updating to the latest firmware.

Kalle
