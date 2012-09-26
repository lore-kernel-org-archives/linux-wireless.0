Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:58834 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853Ab2IZLoA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2012 07:44:00 -0400
Received: by oagh16 with SMTP id h16so426338oag.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 Sep 2012 04:44:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5062E0CB.6040308@gmail.com>
References: <5062E0CB.6040308@gmail.com>
Date: Wed, 26 Sep 2012 17:14:00 +0530
Message-ID: <CAD2nsn2GgFbMXA+w3kd7HowLR+jNr-X0A5JZgQpkOwjTgQgMwQ@mail.gmail.com> (sfid-20120926_134405_193677_0435A572)
Subject: Re: ath6kl ar6004/ar9374 (hw 1.3) WPA/WPA2 supported ?
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Ben Gray <ben.r.gray@gmail.com>
Cc: linux-wireless@vger.kernel.org, ath6kl-devel@qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Wed, Sep 26, 2012 at 4:32 PM, Ben Gray <ben.r.gray@gmail.com> wrote:
> Hi,
>
>     I have a bunch of UB134 USB dongles which have a ath6kl chip with H/W
> version 0x31c8088a, I'm trying to get them to work with the ath6kl driver
> from the compat-wireless-3.6-rc5-1 package. I've applied this
> (https://patchwork.kernel.org/patch/1203191/) patch to the source and pulled
> the hw1.3 firmware from the linux-firmware git.
>
>     The driver works as far as it can scan AP's and connect to unencrypted
> networks, however WPA/WPA2 doesn't work when I run wpa_supplicant. I realise
> "WPA doesn't work" is a bit vague, and I can post the wpa_supplicant and
> driver logs if that helps, but I've seen another post which says they
> couldn't get WPA to work either, so I'd like to know if this is a known
> issue with the driver and/or firmware? Has anyone had any luck getting
> WPA/WPA2 working with ath6kl hw1.3 ?

let us check this out and would let you know the fix. I will ask more
information, once i
start recreating the issue.

>
>     If this is a known issue does anyone know when it might be fixed ?
>
>
> Thanks in advance,
> Ben.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
thanks,
shafi
