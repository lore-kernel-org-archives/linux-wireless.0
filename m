Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from os-mail-3.tamu.edu ([165.91.23.217]:17331 "EHLO
	os-mail-3.tamu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757162Ab1ELOGr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 10:06:47 -0400
Received: by bwz15 with SMTP id 15so1314046bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 12 May 2011 06:57:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DCB3DFF.1030809@lockie.ca>
References: <BANLkTikOw0j8hLBRf6m1p7REpJvNf3mqCw@mail.gmail.com>
	<4DCB3DFF.1030809@lockie.ca>
Date: Thu, 12 May 2011 08:57:14 -0500
Message-ID: <BANLkTi=qeUO4SR2Op2QzQaSB-8TBzcdSPA@mail.gmail.com> (sfid-20110512_160728_523837_DC9738D7)
Subject: Re: rtl8192ce.ko doesn't work with 802.11n?
From: Songgang Xu <sxu@tamu.edu>
To: James <bjlockie@lockie.ca>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you for the reply. I think N network in the university is OK.
Because,  old computer connected it without any problem. The windows
system can also connect it. From the output of wpa_supplicant, the
authentication part works well. I've tried to use the latest drive
from realtek. The firmware distribute is exactly the same as that in
Ubuntu 11.04. But this will make core dump.

I will try some other distributions. But the driver and the kernel are
the same,  so I don't think this will make any difference.

On Wed, May 11, 2011 at 8:55 PM, James <bjlockie@lockie.ca> wrote:
> On 05/11/11 15:29, Flaminigo wrote:
>> MY university deployed 802.11n wireless LAN. However, my new T420
>> cannot connect to the network under ubuntu 11.04. I found the driver
>> for realtek 8188CE is rtl8192ce.ko, rtlwifi. I asked network
>> administrator to help me. They told me my wireless adapter didn't work
>> well with the 802.11n network. Is this because of the driver? The
>> following are the wpa_supplicant output. FYI
>
> Is there another N network you can try (preferably unencrypted)?
>
> Or can you try the card under Windows?
>
> Try a bunch of other distros on livecds (or USBs).
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Regards
Songgang
