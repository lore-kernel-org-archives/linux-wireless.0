Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:53827 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756670Ab2KHUwj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Nov 2012 15:52:39 -0500
From: Bing Zhao <bzhao@marvell.com>
To: "Shen, Jackey" <Jackey.Shen@amd.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 8 Nov 2012 12:52:30 -0800
Subject: RE: Marvell Avastar 88W8797 firmware
Message-ID: <477F20668A386D41ADCC57781B1F7043083BBD6CA7@SC-VEXCH1.marvell.com> (sfid-20121108_215252_488985_F1712479)
References: <0C8FBB70FF40A94D98BE847F9C171A98033D23B0@SCYBEXDAG02.amd.com>
In-Reply-To: <0C8FBB70FF40A94D98BE847F9C171A98033D23B0@SCYBEXDAG02.amd.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jackey,

> Hi Bing,
> 
> Where can I download sd8797_uapsta.bin and usb8797_uapsta.bin?

If you have a rev B0 SD8797 card, you can get sd8797_uapsta.bin firmware image here:

git://git.marvell.com/mwifiex-firmware.git
http://git.marvell.com/?p=mwifiex-firmware.git;a=summary

USB8797 firmware image has not been posted to upstream yet.

> 
> I read "Avastar 88W8797 SoC Product Brief", and want to know how to > select SDIO interface as Host interface described at section " HOST > INTERFACES" in this doc? Now I can use USB interface to surfing the > internet.

Please get help from customer support personnel or the person who supplied the 8797 hardware.

Thanks,
Bing

