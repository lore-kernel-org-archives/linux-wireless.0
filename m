Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mantis.wzyboy.im ([199.83.51.51]:37508 "EHLO mantis.wzyboy.im"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535Ab3KHElp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Nov 2013 23:41:45 -0500
MIME-Version: 1.0
In-Reply-To: <CALkVjQZcKrEFYBzFOXRKhX_cPos9pt0iYnQUnpEEmGzR6+3zQw@mail.gmail.com>
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
 <CALkVjQaHYpR4Tifbt7nh4VeQSrOz5J-xxSrUBKX2kXCZcvkivA@mail.gmail.com> <CALkVjQZcKrEFYBzFOXRKhX_cPos9pt0iYnQUnpEEmGzR6+3zQw@mail.gmail.com>
From: wzyboy <wzyboy@wzyboy.org>
Date: Fri, 8 Nov 2013 12:41:28 +0800
Message-ID: <CALkVjQZWYn8BLnDNxUOkxGhORXeD3OK6sBeu54usEXPtrCRkSQ@mail.gmail.com> (sfid-20131108_054150_171527_DDE6095C)
Subject: Re: [Ilw] Intel Wireless 7260 hardware timed out randomly
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

it seems that I might find one possible "trigger" of this bug: heavy download.

Today I'm trying to download a big file with wget, and this bug occurs
six times before I could not bear it any more (every time I have to
reboot to recover my network!) and bought a network cable downstairs
in the supermarket and used wired network instead.

It seems that when downloading at full speed (20 Mbps fiber, ~2.3
MiB/s) for several minutes and the bug, very possibly, may occur.

Several days ago, when I tried to download "linux-3.12.tar.xz" from
kernal.org with wget, the bug also occured twice during the whole
download process.

Could this be a hardware issue (flawed hardware?) or just driver
issue? I bought this laptop 8 days ago and wiped the pre-installed
Windows the moment I got it, so I have no idea how this wireless card
performs under Windows.

-- 
wzyboy
