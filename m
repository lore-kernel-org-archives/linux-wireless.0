Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932409AbZLDUyp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Dec 2009 15:54:45 -0500
Subject: Re: status of rt2870 support
From: Dan Williams <dcbw@redhat.com>
To: matthieu castet <castet.matthieu@free.fr>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4B196F20.2020005@free.fr>
References: <4B196F20.2020005@free.fr>
Content-Type: text/plain
Date: Fri, 04 Dec 2009 12:54:57 -0800
Message-Id: <1259960097.27022.77.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-12-04 at 21:20 +0100, matthieu castet wrote:
> Hi,
> 
> I downloaded the compat-wireless-2009-12-03 and tried it on my d-link rt2870 usb dongle.
> 
> After doing a ifconfig up, I start a scaning.
> And the scaning show weird stuff :
> - there is lot's of "IE: Unknown". [1]

Expected.  You probably want to use 'iw' instead.

> - not all AP are showed. Even those with very good signal.

Probably a bug.

Dan

> Is that normal ?
> 
> 
> Matthieu
> 
> [1]
>           Cell 03 - Address: 0E:58:1C:E3:D7:BA
>                     Channel:10
>                     Frequency:2.457 GHz (Channel 10)
>                     Quality=70/70  Signal level=35 dBm  
>                     Encryption key:off
>                     ESSID:"FreeWifi"
>                     Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 9 Mb/s
>                               18 Mb/s; 36 Mb/s; 54 Mb/s
>                     Bit Rates:6 Mb/s; 12 Mb/s; 24 Mb/s; 48 Mb/s
>                     Mode:Master
>                     Extra:tsf=000000138750bbcf
>                     Extra: Last beacon: 200ms ago
>                     IE: Unknown: 00084672656557696669
>                     IE: Unknown: 010882848B961224486C
>                     IE: Unknown: 03010A
>                     IE: Unknown: 2A0104
>                     IE: Unknown: 32040C183060
>                     IE: Unknown: 2D1A6E1017FFFF000001000000000000000000000000000000000000
>                     IE: Unknown: 3D160A070000000000000000000000000000000000000000
>                     IE: Unknown: 3E0100
>                     IE: Unknown: DD180050F2020101000003A4000027A4000042435E0062322F00
>                     IE: Unknown: 7F0101
>                     IE: Unknown: DD07000C4300000000
>                     IE: Unknown: DD1E00904C336E1017FFFF000001000000000000000000000000000000000000
>                     IE: Unknown: DD1A00904C340A070000000000000000000000000000000000000000
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

