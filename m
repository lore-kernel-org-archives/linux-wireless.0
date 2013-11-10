Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:53110 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab3KJLc3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Nov 2013 06:32:29 -0500
MIME-Version: 1.0
In-Reply-To: <CALkVjQZEs1CqMEVApDDGZ6FDugPZ+-F5wzvE45+jB5Xrhv_N2A@mail.gmail.com>
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
	<CAErSpo6ry6cUaVngozS8-P44=LPJN6cbsZ_mfWkJv9Rn85YXUQ@mail.gmail.com>
	<CALkVjQZEs1CqMEVApDDGZ6FDugPZ+-F5wzvE45+jB5Xrhv_N2A@mail.gmail.com>
Date: Sun, 10 Nov 2013 13:32:27 +0200
Message-ID: <CANUX_P33UqkCsfHrJW+gx-ZbEQduJ1EZ59fpx6T6wQWOLufSqg@mail.gmail.com> (sfid-20131110_123234_750215_35929A2E)
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

On Sun, Nov 10, 2013 at 12:19 PM, wzyboy <wzyboy@wzyboy.org> wrote:
> 2013/11/9 Bjorn Helgaas <bhelgaas@google.com>:
>> it might
>> be interesting to do "echo on >
>> /sys/bus/pci/devices/0000:03:00.0/power/control" and see whether it
>> makes a difference.
>
>
> Hi, should I run this command after the bug? I just ran this after the
> bug occurs, but there is no output in dmesg, and "ip link set wlan0
> up" still returns same error ("RTNETLINK answers: Connection timed
> out").
>
> --

HW people seem to want to know what happens in you disable L1 substates.
Can you enter you BIOS and check if you have such an option in your BIOS?
