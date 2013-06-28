Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:39428 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346Ab3F1RgA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jun 2013 13:36:00 -0400
Received: by mail-ea0-f182.google.com with SMTP id d10so1189626eaj.13
        for <linux-wireless@vger.kernel.org>; Fri, 28 Jun 2013 10:35:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALyZvKxCYaU47jb98FcbwNSMxnQ8pVCj17MYm0B3V99Uw2_nDA@mail.gmail.com>
References: <CALyZvKxCYaU47jb98FcbwNSMxnQ8pVCj17MYm0B3V99Uw2_nDA@mail.gmail.com>
Date: Fri, 28 Jun 2013 18:35:58 +0100
Message-ID: <CALyZvKyXf_PutHs0KN010phQsJCLWJG1fV=0mrtAOCtfyVGT+g@mail.gmail.com> (sfid-20130628_193604_587770_3E147CB7)
Subject: Fwd: HP6715b laptop's wireless radio on LED went off after 1st boot
 of 3.9.6 from 3.4.4 - please help / any ideas ?
From: Jason Vas Dias <jason.vas.dias@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi - I'd really appreciate some help with this - anyone know how to
force b43  firmware
download with udev to a device that does not appear in lspci output
because a button
is seen as being in the "off" state ( my broadcom 4311 SSB wireless -
dmesg logs from
when button was in "on" state available showing PCI address ) .
Anyone running a HP 6715b
laptop with b43-phy-es loaded into 3.9.6 successfully ?  Was fine with
3.4.4 but then firmware
download occurred and since then no wireless (blue led off after bios
post) . Any ideas pls ?
Thx, Jason
---------- Forwarded message ----------
From: Jason Vas Dias <jason.vas.dias@gmail.com>
Date: Thu, 27 Jun 2013 21:38:30 +0100
Subject: HP6715b laptop's wireless radio on LED went off after 1st
boot of 3.9.6 from 3.4.4 - please help / any ideas ?
To: linux-kernel@vger.kernel.org

After building and installing 3.9.6 kernel & modules on
my 2.2ghz HP6715b x86-64 Turion dual core laptop ,
which has always run Linux with no b43 wireless problems
since 2007, now has no access to its onboard broadcom 4311
wireless radio .  I had always used the b43
driver with the correct firmware installed
under /lib/firmware/b43 with b43-fwcutter
as per instructions at http://wireless.kernel.org/en/users/Drivers/b43
, which I've just now redone again, but since booting
3.9.6, which I believe resulted in a firmware download
via udev at first boot, the wireless radio "on" blue LED
indicator goes off after BIOS POST .  It has always been
the case that if the blue LED indicator is off after BIOS
POST ,  then the kernel does not see the device, and I
have no wireless until a hard poweroff and pressing
the touch sensitive wireless on button during BIOS POST.
But now the wireless LED goes on for @ 1 second during
BIOS POST , and never comes on again ,  and there are
no responses to touching wireless-on button after reboot,
though there are to other buttons next to it.  In short,
I've lost wireless access (and home internet access for
my pc - I'm sending this from my mobile) . Can anyone help?
How can I force the card to download the re-installed
b43-fwcutter firmware, if the device no longer appears
in lspci output?  Anyway to force the kernel to ignore
the wireless button ( it could be that the kernel & bios
think this button is in the off state - any way to force
its state to "on") ?  Any ideas / suggestions would be much
appreciated.
Thanks & Regards, Jason
