Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:45932 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab2GYSyf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2012 14:54:35 -0400
Received: by vcbfk26 with SMTP id fk26so875714vcb.19
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2012 11:54:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50103BE8.1020203@lwfinger.net>
References: <CAAT9HsjZ7wPbkRMH94HDNBS+vOhLigKLYULqfyQobh_Oyt9M4w@mail.gmail.com>
 <501030E9.3090707@lwfinger.net> <CAAT9Hshwb+iPMALGvP1P2UHzEQbyvYNM0_zz0dHp0mJuy6KwLA@mail.gmail.com>
 <50103BE8.1020203@lwfinger.net>
From: Tim and Alison Bentley <Home@TRARBentley.net>
Date: Wed, 25 Jul 2012 19:54:14 +0100
Message-ID: <CAAT9HsjQ_tkm77NT_Rn5_Pi9BHGhY9Vz7jcVzkwdDUjUoKamtw@mail.gmail.com> (sfid-20120725_205438_673869_B5D2091A)
Subject: Re: New Laptop and Driver
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 July 2012 19:33, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 07/25/2012 01:00 PM, Tim and Alison Bentley wrote:
>>
>> 01:00.0 VGA compatible controller [0300]: nVidia Corporation Device
>> [10de:0de9] (rev a1)
>> 03:00.0 Network controller [0280]: Atheros Communications Inc. Device
>> [168c:0037] (rev 01)
>> 04:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd.
>> RTL8111/8168B PCI Express Gigabit Ethernet controller [10ec:8168] (rev
>> 07)
>
>
> The Realtek device is the one used for your wired network.
>
> The Atheros device is not in the tables for the latest version of any
> wireless driver. Perhaps it will work if you do the following:
>
> su -
> modprobe -v ath9k
> echo "168c 0037" > /sys/bus/pci/drivers/ath9k/new_id
> exit
>
> The above will work if the driver handles the device, but it is not yet in
> the tables. Perhaps the Atheros developers will know the status of that
> device.
>
> When replying to E-mail in this list, and most other technical mailing
> lists, please do not top post. Always put your answer below the quoted
> material as I did here.
>
> Larry
>
>
>
Sorry for top posting, bad habbit
No luck with the suggestion and I tried a reboot for luck with no success.


-- 
Tim and Alison Bentley
Home@TRARBentley.net
