Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:2281 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751470Ab0DJJBp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Apr 2010 05:01:45 -0400
Message-ID: <4BC03E77.1050003@gmail.com>
Date: Sat, 10 Apr 2010 11:01:43 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 0/9] rt2x00: Align with vendor driver and add support
 for rt3070/rt3071/rt3090/rt3390.
References: <1270763437-29526-1-git-send-email-gwingerde@gmail.com> <201004090016.53743.IvDoorn@gmail.com>
In-Reply-To: <201004090016.53743.IvDoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/09/10 00:16, Ivo van Doorn wrote:
> On Thursday 08 April 2010, Gertjan van Wingerde wrote:
>> This patch series aligns rt2x00 with the latest versions of the Ralink 
>> rt2860 / rt2870 / rt3070 / rt3090 drivers, and adds support for RT3070,
>> RT3071, RT3090, and RT3390 based devices.
>>
>> The patches are relative to wireless-next-2.6, and can also be pulled
>> from:
>>
>> 	git://git.gwingerde.nl/rt2x00-next-2.6
> 
> Any idea what the status is of rt2870 and rt2770 devices after this series?
> 

To be honest I only could get my RT2870 device (which is actually identified as an
RT2860) to scan properly when I tested it.
However, I had major USB connection issues with that device at the time, so the USB
connectivity would not survive a association / authentication cycle towards my WPA2-
protect network.

However, I did manage to connect to this network with my RT3070 device, so I have
no reason to believe that things would be different for RT2870.

One thing that I believe is still missing for the whole RT28xx/RT3xxx devices is
proper 802.11n support. I am not sure about that, as I haven't really investigated
that yet, but my feeling, based on what other drivers had to do to support 802.11n,
is that we need more work inside rt2x00 to properly support 802.11n.

---
Gertjan.
