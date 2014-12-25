Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:43687 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbaLZKid (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Dec 2014 05:38:33 -0500
Received: by mail-wg0-f41.google.com with SMTP id y19so14328579wgg.0
        for <linux-wireless@vger.kernel.org>; Fri, 26 Dec 2014 02:38:32 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Christopher Chavez <chrischavez@gmx.us>
Cc: linux-wireless@vger.kernel.org
Subject: Re: p54usb kernel panic on recent mainline kernels
Date: Thu, 25 Dec 2014 23:27:13 +0100
Message-ID: <94642933.uAVENFRu8I@debian64> (sfid-20141226_113838_995697_D2DE8327)
In-Reply-To: <CAAFQ00kq-5+TFkH+i5fMXATxVCy-DeLP4G+D6+dxDSRo-fh6Xw@mail.gmail.com>
References: <CAAFQ00kq-5+TFkH+i5fMXATxVCy-DeLP4G+D6+dxDSRo-fh6Xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On Wednesday, December 24, 2014 10:39:55 PM Christopher Chavez wrote:
> When a device using p54usb joins/connects/associates with an access
> point, a kernel panic occurs.
I've just got out one of two of my p54usb devices. My device is able
scan, connect, receive and pass traffic to and from my WPA2 AP without
causing any panics.

> The AP tested uses WPA2; have not tested whether the issue occurs for
> other security types or ad hoc connections. The specific devices
> tested are 2Wire 802.11g USB v1 (vendor 1630 device 0005).
All I have are p54usb V2 devices [Specifically, Dell 1450 USB V2]. 
I don't know if V1 works or not - So, this might actually be the
culprit right here.

> The firmware used is 2.13.1.0.lm86.arm (a.k.a. "isl3886usb" 
> recommended on wireless.kernel.org). Tested on Ubuntu 14.10,
> 32-bit x86 (have not tested 64-bit or other architectures).
V2 firmware (due to V2 device). I only have 64-Bit arch. 

> Tested on machines with Intel and SiS USB chipsets.
It works with the Intel Z87 chipset I have. Don't know
about other chipsets from different vendors.

> I can try collecting more info (e.g. dmesg output), and am currently 
> bisecting the kernel somewhere around 3.17-rc1.
I'm running 3.19-rc1(-wl). I haven't seen or heard anything wrong
with it in the past. It is supposed to work.

> Should this be reported as a kernel bug or with the driver?
"no special mailing list, use the linux wireless list 
<yes, linux-wireless@vger.kernel.org is fine> for development
and firmware issues."

<http://wireless.kernel.org/en/users/Drivers/p54#Contact>

I can't really dig into anything specific to v1 [no device],
chipset or usb-subsystem. It would be nice if you can capture
a crash and post it [preferably with the right subsystem in CC].

Regards,

Christian
