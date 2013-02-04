Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:53762 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064Ab3BDTuC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 14:50:02 -0500
Received: by mail-ob0-f172.google.com with SMTP id tb18so6766238obb.17
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2013 11:50:02 -0800 (PST)
Message-ID: <511010E7.8060205@lwfinger.net> (sfid-20130204_205010_824403_987C90EA)
Date: Mon, 04 Feb 2013 13:49:59 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Thomas Rosenkranz <tom.rosary@googlemail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: FW: 0bda:819a RTL8188CUS WLAN doesn't work out of the box in
 downstream and upstreamkernel
References: <CAOAX8-kdHOiSWZAVrhRfF94a60QdAT3VfCy9Y+1W9A=i-bzFLQ@mail.gmail.com>
In-Reply-To: <CAOAX8-kdHOiSWZAVrhRfF94a60QdAT3VfCy9Y+1W9A=i-bzFLQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/04/2013 11:50 AM, Thomas Rosenkranz wrote:
> regarding to:
> 0bda:819a RTL8188CUS WLAN doesn't work out of the box in downstream
> and upstreamkernel
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1102179
>
> xose.vazquez@gmail.com wanted me to test in different system the
> following commands:
>
> # sudo su
> # modprobe -v rtl8192cu
> # echo "0bda 819a" > /sys/bus/usb/drivers/rtl8192cu/new_id
> (# dmesg (log output))
>
> then X crashes with the echo command and I see the dmesg output
> I can't get back to X and I'm not able to reach any tty-shell.
>
> Tested with 64bit-isos Ubuntu 12.04 / 12.10 / Fedora 17 / Fedora
> 18beta and upstream kernel linux-image-3.8.0-030800rc4-generic

You are likely crashing more than X.

That is very good evidence that rtl8192cu is *NOT* the correct driver for that 
device. As I recall Xose found that USB ID in a Windows driver, but who knows 
what changes are inside that driver?

I have what I think is a complete collection of Realtek drivers for Linux, and 
none of them have 0bda:819a as a USB ID.

Larry


Larry


