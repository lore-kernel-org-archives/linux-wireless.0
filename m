Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f45.google.com ([209.85.192.45]:32979 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbcDZJAs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 05:00:48 -0400
Received: by mail-qg0-f45.google.com with SMTP id f92so2710745qgf.0
        for <linux-wireless@vger.kernel.org>; Tue, 26 Apr 2016 02:00:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAL3+40H6tHomoXqAL=m7F5OT4X8+qAm7RGsUyCMw1=U6ROyqhg@mail.gmail.com>
References: <CAL3+40H6tHomoXqAL=m7F5OT4X8+qAm7RGsUyCMw1=U6ROyqhg@mail.gmail.com>
Date: Tue, 26 Apr 2016 03:00:47 -0600
Message-ID: <CAAA5faGvdC++CTVLKZz8SWXMi6fjbM+r9f9xQ-NA+b_EFavVPw@mail.gmail.com> (sfid-20160426_110055_921454_664997AA)
Subject: Re: Intel 7260 AC only using 802.11n not AC
From: Reinoud Koornstra <reinoudkoornstra@gmail.com>
To: Radu P <rrrpan@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Btw, iwconfig is deprecated, you should use iw instead.
Another way of seeing it:

reinoud@router-dev:/var/log$ sudo iw dev wlp4s0 link
Connected to 00:30:44:1d:cf:2b (on wlp4s0)
       SSID: Mipam5g
       freq: 5240
       RX: 1134508422 bytes (1235653 packets)
       TX: 120716536 bytes (668942 packets)
       signal: -60 dBm
       tx bitrate: 400.0 MBit/s VHT-MCS 9 40MHz short GI VHT-NSS 2

       bss flags:      short-slot-time
       dtim period:    1
       beacon int:     100

again, VHT, hence 11ac. :)

On Tue, Apr 26, 2016 at 1:20 AM, Radu P <rrrpan@gmail.com> wrote:
> Hello,
>
> These is the relevant data:
>
> firmware-version: 17.265642.0
>
> [  292.689871] iwlwifi 0000:04:00.0: loaded firmware version
> 17.265642.0 op_mode iwlmvm
> [  292.702902] iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band
> Wireless AC 7260, REV=0x144
>
> wlan1     IEEE 802.11abgn <- not AC
>
> Kernel version: 4.4.0-21-generic #37~14.04.1-Ubuntu
>
> AC mode is working with Windows 10.
>
> Any help is appreciated!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
