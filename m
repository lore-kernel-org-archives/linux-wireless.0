Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64566 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932820Ab1JDTDh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 15:03:37 -0400
Received: by ywb5 with SMTP id 5so810588ywb.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Oct 2011 12:03:37 -0700 (PDT)
Message-ID: <4E8B5886.3010103@lwfinger.net> (sfid-20111004_210340_777693_D2FAD555)
Date: Tue, 04 Oct 2011 14:03:34 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jamie Kitson <jamie@kitten-x.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: BUG: Soft lockup CPU#0 stuck for 22s! [wpa_supplicant:756]
References: <CA+z-pWFvBfvqY9_km8t3Xbmt=2Pw7eJo8T+SyFp=Lv=d1+ZOPw@mail.gmail.com>
In-Reply-To: <CA+z-pWFvBfvqY9_km8t3Xbmt=2Pw7eJo8T+SyFp=Lv=d1+ZOPw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/04/2011 01:03 PM, Jamie Kitson wrote:
> Hi,
>
> I get the following error when cold booting, it doesn't seem to happen
> after a restart:
>
> http://www.flickr.com/photos/jamiekitson/6211329161/
>
> I have just moved my installation to a new machine with a:
>
> 03:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8188CE
> 802.11b/g/n WiFi Adapter (rev 01)
>          Subsystem: Realtek Semiconductor Co., Ltd. Device 8195
>          Kernel driver in use: rtl8192ce
>          Kernel modules: rtl8192ce
>
> Linux jamie-laptop 3.0-ARCH #1 SMP PREEMPT Tue Aug 30 08:53:25 CEST
> 2011 x86_64 Intel(R) Core(TM) i5-2410M CPU @ 2.30GHz GenuineIntel
> GNU/Linux
>
> I am reporting it here as I assume it's a rtl8192ce bug, but if not I
> can report it to the wpa_supplicant guys.

The bug is not necessarily caused by rtl8192ce. I have never seen this problem 
on my system. I would also expect a stack dump. Anyone know what is needed to 
get one here?

I do have some further questions.

Which variant of the RTL8188CE do you have? Use 'lspci -nn' to tell.

Does ARCH have an updated kernel later than 3.0?

What version of wpa-supplicant?

Are you using NetworkManager? If so, what version? Is your desktop KDE, Gnome, 
or something else? If NM, what applet and version?

If not NM, how do you connect?

Larry
