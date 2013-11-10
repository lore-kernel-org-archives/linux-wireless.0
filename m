Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:49285 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab3KJHDS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Nov 2013 02:03:18 -0500
MIME-Version: 1.0
In-Reply-To: <CALkVjQYkAWrwRabQfBSvC1pm47ZyRT5jQ0mYBwbiGh-Bt29gbg@mail.gmail.com>
References: <5276134B.8070808@wzyboy.org>
	<CALkVjQYh-SUte4S6LdqOc3KSc3_pDU6jz1KXp+Jsd5_RFPXSqA@mail.gmail.com>
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
	<527A8166.6000701@gmail.com>
	<CAErSpo5H9Mf-xmdzThudNO2WHAOt-1T7CQZvgGUmK4jm7_zf+g@mail.gmail.com>
	<CALkVjQaHYpR4Tifbt7nh4VeQSrOz5J-xxSrUBKX2kXCZcvkivA@mail.gmail.com>
	<CAErSpo5dX=cPdThxi-ok=B4beo_jPv2n2n0C1u4UyZMbQDMxqg@mail.gmail.com>
	<CALkVjQYkAWrwRabQfBSvC1pm47ZyRT5jQ0mYBwbiGh-Bt29gbg@mail.gmail.com>
Date: Sun, 10 Nov 2013 09:03:16 +0200
Message-ID: <CANUX_P2x3r4afsa7PFrexE0Kxtd5t-nak+ao+CqvLKZyMha0_g@mail.gmail.com> (sfid-20131110_080335_278400_4D53D5C8)
Subject: Re: [Ilw] Intel Wireless 7260 hardware timed out randomly
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: wzyboy <wzyboy@wzyboy.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
>
> Sorry I used the wrong command...
>
> I've attached the output of -vvxxx below.
>
> There are three files:
>
> * lspci.vvxxx.normal.txt: When the interface is "state DOWN" in "ip link".
> * lspci.vvxxx.normal2.txt: When the interface is "state UP" in "ip
> link" after I ran "ip link set wlan0 up".
> * lspci.vvxxx.normal3.txt" When the interface is connected to the
> Wi-Fi of my dormitory and got an address (but without default
> gateway, I'm using wired network now).
>

one more thing?
Are you using KVM with pass-through? Or is it a native installation?
