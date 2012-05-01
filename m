Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.lenbrook.com ([216.94.44.85]:56151 "EHLO mail.lenbrook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756450Ab2EATcb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 May 2012 15:32:31 -0400
Message-ID: <4FA036B6.7040002@lenbrook.com> (sfid-20120501_213235_037682_36562382)
Date: Tue, 01 May 2012 15:17:10 -0400
From: Jonathan Bagg <jbagg@lenbrook.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: Anthony Ginger <mapfly@gmail.com>, linux-wireless@vger.kernel.org,
	ath6kl-devel@qualcomm.com
Subject: Re: ath6kl hostapd
References: <CAK0tYSKLhALwUca2LPiRLfXTK-Qt3Oh3Lvk=V272AXdb=aAP7w@mail.gmail.com> <4F4B25F5.4090204@qca.qualcomm.com> <4F8546C7.40703@qca.qualcomm.com>
In-Reply-To: <4F8546C7.40703@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12-04-11 04:54 AM, Kalle Valo wrote:
>
> With latest firmware 3.2.0.144 (which I submitted to linux-firmware.git
> yesterday) and latest hostapd from git I can create a WPA-PSK network
> using hostapd and my Nokia N900 succesfully connected to the network and
> I was able to ping N900.
>
> If this is not working for you I recommend updating to the latest firmware.
>
> Kalle
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Kalle,

When you tried hostapd on the N900, did you use a kernel built from your 
https://github.com/kvalo/ath6kl.git or from compat-wireless?

Jon
