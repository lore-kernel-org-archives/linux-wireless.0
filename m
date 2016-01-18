Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:36416 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbcARBDQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2016 20:03:16 -0500
Received: by mail-ob0-f169.google.com with SMTP id ba1so561824301obb.3
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jan 2016 17:03:15 -0800 (PST)
Subject: Re: Fwd: 8192 WiFi Realtek 8192E disconnects after a while and fails
 to reconnect
To: Mateusz Kulikowski <mateusz.kulikowski@gmail.com>,
	gilbertdion@gmail.com, wlanfae@realtek.com,
	chaoming_li@realsil.com.cn
References: <CAKQFV0H+K46CO62w=9yNRvVaOpwmDj3UKXD0QOmF1XPs54GwnQ@mail.gmail.com>
 <CAKQFV0EV9WvmzJaUaFEGODc-kxpt=rXJVYe5Md4oM5H00cBaeQ@mail.gmail.com>
 <568EE125.1030103@gmail.com> <569C10A9.8020200@gmail.com>
Cc: linux-wireless@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <569C39D0.4060909@lwfinger.net> (sfid-20160118_020322_152662_73173101)
Date: Sun, 17 Jan 2016 19:03:12 -0600
MIME-Version: 1.0
In-Reply-To: <569C10A9.8020200@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/17/2016 04:07 PM, Mateusz Kulikowski wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA256
>
> Hi Gilbert,
>
> Small update from my side - It took me a while to setup x86_64 machine,
> but today was finally able to do test.
>
>
> My result are the same as Larry:
> I got my board running for ~4 hours and there was no disconnect.
> For part of the time I was doing (some) activity, for around hour machine
> was idle.
>
> I also did suspend-resume cycle.
>
> System: Ubuntu 15.04 (from usb stick), kernel 3.19.0-15-generic, x86_64
> Machine: MSI AM1I, Sempron 2650,
> PCIe to mini-pcie "wifi" bridge (with antenna connector and proper RFKILL
> wiring).
>
>
> Are you able to do more troubleshooting?
>
> Perhaps try different AP/Channel/mode, (dis)connect power cable from laptop etc.
>
> I'll try to make another reproduction attempt, as without being able
> to reproduce it I will probably not be able to fix it.

Did you see lots of messages regarding the TX rings in the dmesg output? If so, 
those are errors.

Larry


