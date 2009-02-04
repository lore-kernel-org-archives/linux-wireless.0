Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36923 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbZBDPAu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 10:00:50 -0500
Date: Wed, 4 Feb 2009 09:47:28 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Ismael Ojeda Perez <iojedaperez@gmail.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@gmail.com
Subject: Re: zd1211rw NEW RF Type
Message-ID: <20090204144728.GB3845@tuxdriver.com> (sfid-20090204_160054_272122_AF21ACAA)
References: <a4c529250902040227g35a375fdu35c2360f0916dba6@mail.gmail.com> <a4c529250902040243r6146f56vb2c656818385c749@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a4c529250902040243r6146f56vb2c656818385c749@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 04, 2009 at 10:43:19AM +0000, Ismael Ojeda Perez wrote:
> Hi, huston we have a problem
> I have purchased a tp-link usb wireless device
> model : tl-wn422g
> i cant work with it because it says there is a new RF type
> here its what dmesg shows
> 
> [  503.629054] usbcore: registered new interface driver zd1211rw
> [  522.452184] usb 7-2: new high speed USB device using ehci_hcd and address 5
> [  522.586859] usb 7-2: configuration #1 chosen from 1 choice
> [  522.701176] usb 7-2: reset high speed USB device using ehci_hcd and address 5
> [  522.843643] phy1: Selected rate control algorithm 'pid'
> [  522.846157] zd1211rw 7-2:1.0: phy1
> [  526.888705] firmware: requesting zd1211/zd1211b_ub
> [  526.945146] firmware: requesting zd1211/zd1211b_uphr
> [  526.984508] zd1211rw 7-2:1.0: RF MAXIM_NEW_RF 0x8 is not supported
> [  527.001064] firmware: requesting zd1211/zd1211b_ub
> [  527.007886] firmware: requesting zd1211/zd1211b_uphr
> 
> lsusb command shows this
> Bus 007 Device 005: ID 0ace:1215 ZyDAS WLA-54L WiFi
> 
> im using ubuntu 8.10 linux kernel
> 2.6.27-7-generic
 
Looks like it is still unsupported even in wireless-testing.

> i whould apreciate any help to get this device working i have some
> knowledge of C programming i can try and help you to modify and test
> anything you tellme so we can add this new device to the supported
> list.

Perhaps our inside guy at Atheros (which now owns ZyDAS) can help us
to get some info on this part?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
