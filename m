Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mantis.wzyboy.im ([199.83.51.51]:38133 "EHLO mantis.wzyboy.im"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196Ab3KJHIt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Nov 2013 02:08:49 -0500
MIME-Version: 1.0
In-Reply-To: <CANUX_P2x3r4afsa7PFrexE0Kxtd5t-nak+ao+CqvLKZyMha0_g@mail.gmail.com>
References: <5276134B.8070808@wzyboy.org> <CALkVjQYh-SUte4S6LdqOc3KSc3_pDU6jz1KXp+Jsd5_RFPXSqA@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DE8338@HASMSX103.ger.corp.intel.com>
 <CALkVjQb7fCMFpqhdUs8w-Mx_Y0RtAYYFtKxXkqyrCQ39UFGxKg@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DE960E@HASMSX103.ger.corp.intel.com>
 <CALkVjQbW8FeiEh8pBZ=KQFD9+8AdjgT0G_RG7qJe0MRdBvMD-A@mail.gmail.com>
 <CALkVjQaLx2spaOqUPcs_EwMkU7npMki1Reo1MeZwxB7m=c24=g@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DE9FC6@HASMSX103.ger.corp.intel.com>
 <CALkVjQZDNSgUUFyi94Y8da_NDzW61rCvaMrZpUugFKW_LRNFFA@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DEA052@HASMSX103.ger.corp.intel.com>
 <CALkVjQZRJw7ghjBa1aPKNKe3Zj2B1Mhk5bWVaRdcCYzfoLRovg@mail.gmail.com>
 <CALkVjQY7r=YKhsgDKR0mnYVtZy5BAdj83nY2jL0VFaiew6ha7A@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DEA097@HASMSX103.ger.corp.intel.com>
 <CALkVjQY7uRFQ3Qs9T_bgqnYRNcWgsk5gfd=R8RfGFxOdDpFYTQ@mail.gmail.com>
 <527A8166.6000701@gmail.com> <CAErSpo5H9Mf-xmdzThudNO2WHAOt-1T7CQZvgGUmK4jm7_zf+g@mail.gmail.com>
 <CALkVjQaHYpR4Tifbt7nh4VeQSrOz5J-xxSrUBKX2kXCZcvkivA@mail.gmail.com>
 <CAErSpo5dX=cPdThxi-ok=B4beo_jPv2n2n0C1u4UyZMbQDMxqg@mail.gmail.com>
 <CALkVjQYkAWrwRabQfBSvC1pm47ZyRT5jQ0mYBwbiGh-Bt29gbg@mail.gmail.com> <CANUX_P2x3r4afsa7PFrexE0Kxtd5t-nak+ao+CqvLKZyMha0_g@mail.gmail.com>
From: wzyboy <wzyboy@wzyboy.org>
Date: Sun, 10 Nov 2013 15:08:32 +0800
Message-ID: <CALkVjQYKPjOLcBo34h4Eq6f0bac=z4o+54PuNmcgKRz301JYqg@mail.gmail.com> (sfid-20131110_080911_853018_76938FB1)
Subject: Re: [Ilw] Intel Wireless 7260 hardware timed out randomly
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/11/10 Emmanuel Grumbach <egrumbach@gmail.com>:
> one more thing?
> Are you using KVM with pass-through? Or is it a native installation?


No, I’m using a native installation. I just wiped the pre-installed
Windows OS and booted from Arch Linux installation disk, set up LUKS
(without LVM) and installed the system.

However, as you can see in dmesg "modules linked in", I have
VirtualBox installed and "vboxdrv.ko" loaded.

-- 
wzyboy
